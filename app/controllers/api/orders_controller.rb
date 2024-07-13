class Api::OrdersController < ApplicationController
  def create
    order = order_params

    order_service = OrderService.new(order)

    order_service.transform_currency if order_service.valid?

    render json: order, status: :ok
  rescue => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def order_params
    params.require(:order).permit(:id, :name, :price, :currency, address: [:city, :district, :street])
  end
end
