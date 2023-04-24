# frozen_string_literal: true

class SuppliesController < ApplicationController
  load_and_authorize_resource

  def index
    @query = Supply.order(created_at: :desc)
                   .accessible_by(current_ability)
                   .page(params[:page])
                   .ransack(params[:q])

    @supplies = @query.result(distinct: false)
  end

  def new
    @supply = Supply.new
  end

  def create
    @supply = Supply.new(supply_params)

    if @supply.save
      redirect_success(path: supplies_path, action: 'criado')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def supply_params
    params.require(:supply).permit(Supply.permitted_params).merge(created_by: current_user)
  end

  def redirect_success(path:, action:)
    redirect_to(path)
    flash[:success] = "Suprimento #{action} com sucesso."
  end
end
