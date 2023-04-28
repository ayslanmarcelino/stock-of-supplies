# frozen_string_literal: true

class MovementsController < ApplicationController
  load_and_authorize_resource

  def index
    @query = Movement.includes(:supply, :created_by, :source, :batch)
                  .order(created_at: :desc)
                  .accessible_by(current_ability)
                  .page(params[:page])
                  .ransack(params[:q])

    @movements = @query.result(distinct: false)
  end
end
