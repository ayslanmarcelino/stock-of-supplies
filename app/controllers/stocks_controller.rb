# frozen_string_literal: true

class StocksController < ApplicationController
  load_and_authorize_resource

  def index
    @query = Stock.includes(:supply)
                  .order(created_at: :desc)
                  .accessible_by(current_ability)
                  .page(params[:page])
                  .ransack(params[:q])

    @stocks = @query.result(distinct: false)
    @chart = Stocks::Chart::Create.call(user: current_user)
  end
end
