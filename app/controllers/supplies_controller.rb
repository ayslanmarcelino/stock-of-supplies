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

  def new; end

  def create; end

  private

  def supply_params
    params.require(:supply).permit(Supply.permitted_params).merge(created_by: current_user)
  end
end
