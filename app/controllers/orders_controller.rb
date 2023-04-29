# frozen_string_literal: true

class OrdersController < ApplicationController
  load_and_authorize_resource

  def index
    @orders = Order.all
  end
end
