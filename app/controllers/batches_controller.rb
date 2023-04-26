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
      redirect_success(path: batches_path, action: 'criado')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def batch_params
    params.require(:batch).permit(Batch.permitted_params).merge(created_by: current_user, remaining: params[:batch][:amount])
  end

  def redirect_success(path:, action:)
    redirect_to(path)
    flash[:success] = "Lote #{action} com sucesso."
  end

  def supplies
    @supplies ||= Supply.all
  end
end
