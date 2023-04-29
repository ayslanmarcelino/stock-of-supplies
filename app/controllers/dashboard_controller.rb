# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @chart = Movements::Chart::Build.call(user: current_user)
  end
end
