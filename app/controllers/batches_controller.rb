class BatchesController < ApplicationController
  def index
    @query = Batch.includes(:supply, created_by: :person)
                  .order(created_at: :desc)
                  .accessible_by(current_ability)
                  .page(params[:page])
                  .ransack(params[:q])

    @batches = @query.result(distinct: false)
  end
end
