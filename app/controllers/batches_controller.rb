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
      create_input_stock!(amount: @batch.amount, arrived_date: @batch.arrived_date)
      redirect_success(path: batches_path, action: 'criado')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def increment_amount
    assign_data

    if resource.valid?
      resource.save!
      create_input_stock!(amount: params[:batch][:amount], arrived_date: params[:batch][:arrived_date])
      flash[:success] = "Valor adicionado ao lote #{resource.identifier}."
    else
      flash[:alert] = batch.errors.full_messages.to_sentence
    end

    redirect_to(batches_path)
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

  def create_input_stock!(amount:, arrived_date:)
    Stocks::Create.call(
      params: @batch,
      batch: @batch,
      reason: 'Recebido pelo Estado',
      kind: :input,
      amount: amount,
      arrived_date: arrived_date
    )
  end

  def resource
    @resource ||= Batch.find(params[:id])
  end

  def assign_data
    resource.amount += params[:batch][:amount].to_i
    resource.remaining += params[:batch][:amount].to_i
    resource.arrived_date = params[:batch][:arrived_date] if before?
  end

  def before?
    resource.arrived_date < params[:batch][:arrived_date].to_date
  end
end
