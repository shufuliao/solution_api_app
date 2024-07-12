class Api::OrdersController < ApplicationController
  def create
    render json: { message: "Order created" }, status: :created
  end
end
