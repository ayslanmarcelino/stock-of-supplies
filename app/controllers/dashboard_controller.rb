class DashboardController < ApplicationController
  def index
    @chart = Stocks::Chart::Build.call(user: current_user)
  end
end
