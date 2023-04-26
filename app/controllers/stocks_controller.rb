# frozen_string_literal: true

class StocksController < ApplicationController
  load_and_authorize_resource

  def index
    @query = Stock.includes(:supply, :created_by, :source)
                  .order(created_at: :desc)
                  .accessible_by(current_ability)
                  .page(params[:page])
                  .ransack(params[:q])

    @stocks = @query.result(distinct: false)
  end
end
