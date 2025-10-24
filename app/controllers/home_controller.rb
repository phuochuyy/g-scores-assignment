class HomeController < ApplicationController
  def index
  end

  def test_flash
    flash[:alert] = "Test flash message - this should appear!"
    redirect_to root_path
  end
end
