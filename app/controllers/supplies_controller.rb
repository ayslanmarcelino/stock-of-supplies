# frozen_string_literal: true

class SuppliesController < ApplicationController
  def index
    @query = Supply.order(created_at: :desc)
                   .accessible_by(current_ability)
                   .page(params[:page])
                   .ransack(params[:q])

    @supplies = @query.result(distinct: false)
  end
end
