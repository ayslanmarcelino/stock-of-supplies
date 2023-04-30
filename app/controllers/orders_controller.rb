# frozen_string_literal: true

class OrdersController < ApplicationController
  load_and_authorize_resource

  before_action :supplies, only: [:new, :create]

  def index
    @query = Order.accessible_by(current_ability)
                  .page(params[:page])
                  .ransack(params[:q])

    @orders = @query.result(distinct: false)
  end

  def show; end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      redirect_success(path: orders_path, action: 'solicitado')
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def order_params
    params.require(:order)
          .permit(
            Order.permitted_params
          ).merge(
            requesting_unit: current_user.current_unit,
            created_by: current_user,
            aasm_state: :pending
          )
  end

  def redirect_success(path:, action:)
    redirect_to(path)
    flash[:success] = "Pedido #{action} com sucesso."
  end

  def supplies
    @supplies ||= Supply.all.sort
  end

  def order
    @order ||= Order.find(params[:id])
  end
end
