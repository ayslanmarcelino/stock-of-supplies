# frozen_string_literal: true

class OrdersController < ApplicationController
  load_and_authorize_resource

  before_action :supplies, only: [:new, :create]

  def index
    @query = query
    @orders = @query.result(distinct: false)
  end

  def show
    @versions = @order.versions.includes(:responsible, responsible: :person).order(created_at: :desc)
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      create_order_version!
      redirect_success(path: orders_path, action: 'solicitado')
    elsif @order.amount <= 0
      flash[:alert] = 'Valor deve ser maior que 0'
      redirect_to(new_order_path)
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def approve
    if @order.may_approve?
      @order.approve!(current_user: current_user, order: @order)
      flash[:success] = 'Pedido aprovado com sucesso. Favor separar para envio.'
    elsif @order.approved?
      flash[:alert] = 'Pedido já aprovado.'
    elsif @order.amount >= @order.stock.remaining
      flash[:alert] = 'Pedido não pode ser aprovado. A quantidade solicitada é maior do que a quantidade disponível em estoque.'
    else
      flash[:alert] = 'Pedido não pode ser aprovado.'
    end

    redirect_to(orders_path)
  end

  def reject
    if @order.may_reject?
      reject!
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
      @order.deliver!(current_user: current_user, order: @order)
      flash[:success] = 'Pedido enviado com sucesso.'
    elsif @order.delivered?
      flash[:alert] = 'Pedido já enviado.'
    elsif @order.amount >= @order.stock.remaining
      flash[:alert] = 'Pedido não pode ser enviado. A quantidade solicitada é maior do que a quantidade disponível em estoque.'
    else
      flash[:alert] = 'Pedido não pode ser enviado.'
    end

    redirect_to(orders_path)
  end

  def finish
    if @order.may_finish?
      @order.finish!(current_user: current_user, order: @order)
      flash[:success] = 'Pedido concluído com sucesso.'
    elsif @order.finished?
      flash[:alert] = 'Pedido já foi concluído.'
    else
      flash[:alert] = 'Pedido não pode ser concluído.'
    end

    redirect_to(orders_path)
  end

  private

  def query
    orders_query = Order.includes([created_by: :person], [stock: :supply])

    unless current_user.current_unit.kind_pni?
      orders_query = orders_query.where(requesting_unit: current_user.current_unit)
    end

    orders_query.accessible_by(current_ability)
                .order(created_at: :desc)
                .page(params[:page])
                .ransack(params[:q])
  end

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

  def create_order_version!
    Order::Version.create!(
      order: @order,
      aasm_state: @order.aasm_state,
      responsible: current_user,
      reason: @order.reason
    )
  end

  def reject!
    @order.reject!(
      reason: params[:order][:reason],
      current_user: current_user,
      order: @order
    )
  end
end
