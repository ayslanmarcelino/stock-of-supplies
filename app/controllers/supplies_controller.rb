# frozen_string_literal: true

class SuppliesController < ApplicationController
  def index
    @supplies = Supply.all
  end
end
