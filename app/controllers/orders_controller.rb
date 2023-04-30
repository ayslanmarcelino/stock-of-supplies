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

  def approve
    if @order.may_approve?
      @order.update(approved_by: current_user, approval_date: Time.current)
      @order.approve!
      flash[:success] = 'Pedido aprovado com sucesso. Favor separar para envio.'
    elsif @order.approved?
      flash[:alert] = 'Pedido já aprovado.'
    else
      flash[:alert] = 'Pedido não pode ser aprovado.'
    end

    redirect_to(orders_path)
  end

  def reject
    # adicionar preenchimento de motivo

    if @order.may_reject?
      @order.update(rejected_by: current_user, rejection_date: Time.current)
      @order.reject!
      flash[:success] = 'Pedido reprovado com sucesso.'
    elsif @order.rejected?
      flash[:alert] = 'Pedido já reprovado.'
    else
      flash[:alert] = 'Pedido não pode ser reprovado.'
    end

    redirect_to(orders_path)
  end

  def deliver
    if @order.may_deliver?
      @order.update(delivered_by: current_user, delivery_date: Time.current)
      @order.deliver!
      flash[:success] = 'Pedido enviado com sucesso.'
    elsif @order.delivered?
      flash[:alert] = 'Pedido já enviado.'
    else
      flash[:alert] = 'Pedido não pode ser enviado.'
    end

    redirect_to(orders_path)
  end

  def finish
    if @order.may_finish?
      @order.update(finished_by: current_user, final_date: Time.current)
      @order.finish!
      flash[:success] = 'Pedido concluído com sucesso.'
    elsif @order.finished?
      flash[:alert] = 'Pedido já foi concluído.'
    else
      flash[:alert] = 'Pedido não pode ser concluído.'
    end

    redirect_to(orders_path)
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
