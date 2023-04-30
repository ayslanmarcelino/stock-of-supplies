# frozen_string_literal: true

class MovementsController < ApplicationController
  load_and_authorize_resource

  def index
    @query = Movement.includes(:supply, :source, :stock, created_by: :person)
                     .where(unit: current_user.current_unit)
                     .order(created_at: :desc)
                     .accessible_by(current_ability)
                     .page(params[:page])
                     .ransack(params[:q])

    @movements = @query.result(distinct: false)
  end
end
