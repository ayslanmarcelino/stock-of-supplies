# frozen_string_literal: true

class StocksController < ApplicationController
  load_and_authorize_resource

  before_action :supplies, only: [:new, :create]

  def index
    @query = Stock.includes(:supply, created_by: :person)
                  .order(created_at: :desc)
                  .accessible_by(current_ability)
                  .page(params[:page])
                  .ransack(params[:q])

    @stocks = @query.result(distinct: false)
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(stock_params)

    if @stock.save
      create_movement!(
        amount: @stock.amount,
        arrived_date: @stock.arrived_date,
        kind: :input,
        reason: 'Recebido pelo Estado'
      )
      redirect_success(path: stocks_path, action: 'criado')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def increment_amount
    assign_increment_data

    if input_created_successfully?
      flash[:success] = "Valor adicionado ao estoque #{resource.identifier}."
    elsif params[:stock][:amount].to_i <= 0
      flash[:alert] = 'Quantidade deve ser maior que 0'
    else
      flash[:alert] = increment_amount_error_message
    end

    redirect_to(stocks_path)
  end

  def new_output
    assign_new_output_data

    if date_after_today?
      flash[:alert] = 'Saída deve ser hoje ou antes'
    elsif output_created_successfully?
      flash[:success] = "Saída do estoque #{resource.identifier} criada com sucesso."
    elsif params[:stock][:remaining].to_i <= 0
      flash[:alert] = 'Quantidade deve ser maior que 0'
    else
      flash[:alert] = new_output_error_message
    end

    redirect_to(stocks_path)
  end

  private

  def stock_params
    params.require(:stock)
          .permit(Stock.permitted_params)
          .merge(
            unit: current_user.current_unit,
            created_by: current_user,
            remaining: params[:stock][:amount]
          )
  end

  def redirect_success(path:, action:)
    redirect_to(path)
    flash[:success] = "Estoque #{action} com sucesso."
  end

  def supplies
    @supplies ||= Supply.all
  end

  def resource
    @resource ||= Stock.find(params[:id])
  end

  def create_movement!(amount:, arrived_date:, kind:, reason:)
    Movements::Create.call(
      params: @stock,
      stock: @stock,
      reason: reason,
      kind: kind,
      current_user: current_user,
      amount: amount,
      arrived_date: arrived_date
    )
  end

  def assign_increment_data
    return if params[:stock][:amount].to_i <= 0

    resource.amount += params[:stock][:amount].to_i
    resource.remaining += params[:stock][:amount].to_i
    resource.arrived_date = params[:stock][:arrived_date] if before?
  end

  def before?
    resource.arrived_date < params[:stock][:arrived_date].to_date
  end

  def assign_new_output_data
    return if params[:stock][:remaining].to_i <= 0

    resource.remaining -= params[:stock][:remaining].to_i
  end

  def date_after_today?
    params[:stock][:output_date].to_date > Date.current
  end

  def input_created_successfully?
    resource.valid? &&
      params[:stock][:amount].to_i.positive? &&
      create_movement!(amount: params[:stock][:amount], arrived_date: params[:stock][:arrived_date], kind: :input,
                       reason: 'Recebido pelo Estado') &&
      resource.save!
  end

  def increment_amount_error_message
    resource.errors.full_messages.to_sentence
  end

  def output_created_successfully?
    resource.valid? &&
      @stock.remaining >= params[:stock][:remaining].to_i &&
      create_movement!(amount: params[:stock][:remaining], arrived_date: params[:stock][:output_date], kind: :output,
                       reason: 'Utilizado em pacientes') &&
      resource.save!
  end

  def new_output_error_message
    if resource.remaining <= 0
      'Quantidade da saída ultrapassa a quantidade do estoque. Tente novamente com a quantidade correta.'
    else
      resource.errors.full_messages.to_sentence
    end
  end
end
