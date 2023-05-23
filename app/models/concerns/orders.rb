module Orders
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :pending, initial: true
      state :approved
      state :rejected
      state :delivered
      state :finished

      event :approve, if: :available_stock?, success: :create_order_version! do
        transitions from: :pending, to: :approved
      end

      event :reject, success: [:add_reason!, :create_order_version!] do
        transitions from: :pending, to: :rejected
      end

      event :deliver, if: :available_stock?, success: :create_order_version! do
        transitions from: :approved, to: :delivered
      end

      event :finish, if: :available_stock?,
                     success: [:update_sent_stock!, :find_or_create_received_stock!, :create_output_movement!, :create_input_movement!, :create_order_version!] do
        transitions from: :delivered, to: :finished
      end
    end
  end

  private

  def available_stock?
    stock.remaining >= amount
  end

  def add_reason!(params)
    update(reason: params[:reason])
  end

  def create_order_version!(params)
    Order::Version.create!(
      order: params[:order],
      aasm_state: params[:order].aasm_state,
      responsible: params[:current_user],
      reason: params[:order].reason
    )
  end

  def update_sent_stock!(params)
    stock = Stock.find_by(unit: params[:order].stock.unit, identifier: params[:order].stock.identifier)

    stock.remaining -= params[:order].amount
    stock.save!
  end

  def assign_attributes_to_persisted_stock(params, stock)
    stock.amount += params[:order].amount
    stock.remaining += params[:order].amount
    stock.arrived_date = Date.current
  end

  def assign_attributes_to_new_stock(params, stock)
    stock.assign_attributes(
      amount: params[:order].amount,
      remaining: params[:order].amount,
      supply: params[:order].stock.supply,
      created_by: params[:order].created_by,
      arrived_date: Date.current,
      expiration_date: params[:order].stock.expiration_date
    )
  end

  def find_or_create_received_stock!(params)
    stock = Stock.find_or_create_by(unit: params[:current_user].current_unit, identifier: params[:order].stock.identifier)

    if stock.persisted?
      assign_attributes_to_persisted_stock(params, stock)
    else
      assign_attributes_to_new_stock(params, stock)
    end

    stock.save!
  end

  def create_output_movement!(params)
    Movements::Create.call(
      params: params[:order].stock,
      reason: "Pedido pela UBS - #{params[:order].requesting_unit.name}",
      kind: :output,
      stock: params[:order].stock,
      amount: params[:order].amount,
      current_user: params[:current_user]
    )
  end

  def create_input_movement!(params)
    Movements::Create.call(
      params: params[:order].stock,
      reason: 'Recebido pelo PNI',
      kind: :input,
      stock: Stock.find_by(unit: params[:current_user].current_unit, identifier: params[:order].stock.identifier),
      amount: params[:order].amount,
      current_user: params[:current_user],
      unit: params[:current_user].current_unit
    )
  end
end
