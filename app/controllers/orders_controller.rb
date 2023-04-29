# frozen_string_literal: true

class OrdersController < ApplicationController
  load_and_authorize_resource

  def index
    @query = Order.accessible_by(current_ability)
                  .page(params[:page])
                  .ransack(params[:q])

    @orders = @query.result(distinct: false)
  end
end
