require 'rails_helper'

RSpec.describe Api::OrdersController, type: :controller do
  describe 'POST #create' do
    let(:valid_order_params) do
      {
        order: {
          id: "A0000001",
          name: 'John Doe',
          price: '1000',
          currency: 'USD',
          address: {
            city: 'CityName',
            district: 'DistrictName',
            street: 'StreetName'
          }
        }
      }
    end

    context 'with valid parameters' do
      it 'returns a successful response and currency is TWD' do
        valid_order_params[:order][:currency] = 'TWD'
        post :create, params: valid_order_params
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['currency']).to eq('TWD')
        expect(json_response['price'].to_i).to eq(1000)
      end

      it 'returns a successful response and transforms currency' do
        post :create, params: valid_order_params
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['currency']).to eq('TWD')
        expect(json_response['price'].to_i).to eq(31000)
      end
    end

    context 'with invalid name' do
      it 'returns a bad request response when name include non-English characters' do
        valid_order_params[:order][:name] = 'John Doe1'
        post :create, params: valid_order_params
        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to be_present
        expect(json_response['error']).to eq('Name contains non-English characters')
      end

      it 'returns a bad request response when name is not capitalized' do
        valid_order_params[:order][:name] = 'John doe'
        post :create, params: valid_order_params
        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to be_present
        expect(json_response['error']).to eq('Name is not capitalized')
      end

      it 'returns a bad request response when price is over 2000' do
        valid_order_params[:order][:price] = '2001'
        post :create, params: valid_order_params
        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to be_present
        expect(json_response['error']).to eq('Price is over 2000')
      end

      it 'returns a bad request response when currency format is wrong' do
        valid_order_params[:order][:currency] = 'JPY'
        post :create, params: valid_order_params
        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to be_present
        expect(json_response['error']).to eq('Currency format is wrong')
      end
    end
  end
end
