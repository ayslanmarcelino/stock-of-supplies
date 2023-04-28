# frozen_string_literal: true

class BatchesController < ApplicationController
  load_and_authorize_resource

  before_action :supplies, only: [:new, :create]

  def index
    @query = Batch.includes(:supply, created_by: :person)
                  .order(created_at: :desc)
                  .accessible_by(current_ability)
                  .page(params[:page])
                  .ransack(params[:q])

    @batches = @query.result(distinct: false)
  end

  def new
    @batch = Batch.new
  end

  def create
    @batch = Batch.new(batch_params)

    if @batch.save
      create_stock!(
        amount: @batch.amount,
        arrived_date: @batch.arrived_date,
        kind: :input,
        reason: 'Recebido pelo Estado'
      )
      redirect_success(path: batches_path, action: 'criado')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def increment_amount
    assign_increment_data

    if input_created_successfully?
      flash[:success] = "Valor adicionado ao lote #{resource.identifier}."
    elsif params[:batch][:amount].to_i <= 0
      flash[:alert] = 'Quantidade deve ser maior que 0'
    else
      flash[:alert] = increment_amount_error_message
    end

    redirect_to batches_path
  end

  def new_output
    assign_new_output_data

    if params[:batch][:remaining].to_i <= 0
      flash[:alert] = 'Quantidade deve ser maior que 0'
    elsif output_created_successfully?
      flash[:success] = "Saída do lote #{resource.identifier} criada com sucesso."
    else
      flash[:alert] = new_output_error_message
    end

    redirect_to batches_path
  end

  private

  def batch_params
    params.require(:batch)
          .permit(Batch.permitted_params)
          .merge(
            unit: current_user.current_unit,
            created_by: current_user,
            remaining: params[:batch][:amount]
          )
  end

  def redirect_success(path:, action:)
    redirect_to(path)
    flash[:success] = "Lote #{action} com sucesso."
  end

  def supplies
    @supplies ||= Supply.all
  end

  def create_stock!(amount:, arrived_date:, kind:, reason:)
    Stocks::Create.call(
      params: @batch,
      batch: @batch,
      reason: reason,
      kind: kind,
      amount: amount,
      arrived_date: arrived_date
    )
  end

  def resource
    @resource ||= Batch.find(params[:id])
  end

  def assign_increment_data
    return if params[:batch][:amount].to_i <= 0

    resource.amount += params[:batch][:amount].to_i
    resource.remaining += params[:batch][:amount].to_i
    resource.arrived_date = params[:batch][:arrived_date] if before?
  end

  def before?
    resource.arrived_date < params[:batch][:arrived_date].to_date
  end

  def assign_new_output_data
    @batch.remaining -= params[:batch][:remaining].to_i
  end

  def input_created_successfully?
    resource.valid? &&
      params[:batch][:amount].to_i.positive? &&
      create_stock!(amount: params[:batch][:amount], arrived_date: params[:batch][:arrived_date], kind: :input,
                    reason: 'Recebido pelo Estado') &&
      resource.save!
  end

  def increment_amount_error_message
    resource.errors.full_messages.to_sentence
  end

  def output_created_successfully?
    @batch.valid? &&
      @batch.remaining >= params[:batch][:remaining].to_i &&
      create_stock!(amount: params[:batch][:remaining], arrived_date: params[:batch][:arrived_date], kind: :output,
                    reason: 'Utilizado em pacientes') &&
      @batch.save!
  end

  def new_output_error_message
    if @batch.remaining <= 0
      'Quantidade da saída ultrapassa a quantidade do estoque. Tente novamente com a quantidade correta.'
    else
      @batch.errors.full_messages.to_sentence
    end
  end
end
