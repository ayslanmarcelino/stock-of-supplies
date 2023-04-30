# frozen_string_literal: true

class OrdersController < ApplicationController
  load_and_authorize_resource

  before_action :supplies, only: [:new, :create]

  def index
    @query = Order.includes(:created_by, stock: :supply)
                  .order(:created_at)
                  .accessible_by(current_ability)
                  .page(params[:page])
                  .ransack(params[:q])

    @orders = @query.result(distinct: false)
  end

  def show
    @versions = @order.versions.includes(:responsible, responsible: :person).order(created_at: :desc)
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      create_order_version!
      redirect_success(path: orders_path, action: 'solicitado')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def approve
    if @order.may_approve?
      @order.approve!
      create_order_version!
      flash[:success] = 'Pedido aprovado com sucesso. Favor separar para envio.'
    elsif @order.approved?
      flash[:alert] = 'Pedido já aprovado.'
    else
      flash[:alert] = 'Pedido não pode ser aprovado.'
    end

    redirect_to(orders_path)
  end

  def reject
    # adicionar preenchimento de motivo

    if @order.may_reject?
      @order.reject!
      create_order_version!
      flash[:success] = 'Pedido reprovado com sucesso.'
    elsif @order.rejected?
      flash[:alert] = 'Pedido já reprovado.'
    else
      flash[:alert] = 'Pedido não pode ser reprovado.'
    end

    redirect_to(orders_path)
  end

  def deliver
    if @order.may_deliver?
      @order.deliver!
      create_order_version!
      flash[:success] = 'Pedido enviado com sucesso.'
    elsif @order.delivered?
      flash[:alert] = 'Pedido já enviado.'
    else
      flash[:alert] = 'Pedido não pode ser enviado.'
    end

    redirect_to(orders_path)
  end

  def finish
    if @order.may_finish?
      update_sent_stock!
      find_or_create_received_stock!
      create_output_movement!
      create_input_movement!
      @order.finish!
      create_order_version!
      flash[:success] = 'Pedido concluído com sucesso.'
    elsif @order.finished?
      flash[:alert] = 'Pedido já foi concluído.'
    else
      flash[:alert] = 'Pedido não pode ser concluído.'
    end

    redirect_to(orders_path)
  end

  private

  def order_params
    params.require(:order)
          .permit(
            Order.permitted_params
          ).merge(
            requesting_unit: current_user.current_unit,
            created_by: current_user,
            aasm_state: :pending
          )
  end

  def redirect_success(path:, action:)
    redirect_to(path)
    flash[:success] = "Pedido #{action} com sucesso."
  end

  def supplies
    @supplies ||= Supply.all.sort
  end

  def order
    @order ||= Order.find(params[:id])
  end

  def create_order_version!
    Order::Version.create!(order: @order, aasm_state: @order.aasm_state, responsible: current_user)
  end

  def update_sent_stock!
    stock = Stock.find_by(unit: @order.stock.unit, identifier: @order.stock.identifier)

    stock.amount -= @order.amount
    stock.remaining -= @order.amount
    stock.save!
  end

  def find_or_create_received_stock!
    stock = Stock.find_or_create_by(unit: current_user.current_unit, identifier: @order.stock.identifier)

    if stock.persisted?
      stock.amount += @order.amount
      stock.remaining += @order.amount
      stock.arrived_date = Date.current
    else
      stock.assign_attributes(
        amount: @order.amount,
        remaining: @order.amount,
        supply: @order.stock.supply,
        created_by: @order.created_by,
        arrived_date: Date.current,
        expiration_date: @order.stock.expiration_date
      )
    end

    stock.save!
  end

  def create_input_movement!
    Movements::Create.call(
      params: @order.stock,
      reason: 'Recebido pelo PNI',
      kind: :input,
      stock: @order.stock,
      amount: @order.amount,
      current_user: current_user,
      unit: current_user.current_unit
    )
  end

  def create_output_movement!
    Movements::Create.call(
      params: @order.stock,
      reason: "Pedido pela UBS - #{@order.requesting_unit.name}",
      kind: :output,
      stock: @order.stock,
      amount: @order.amount,
      current_user: current_user
    )
  end
end
