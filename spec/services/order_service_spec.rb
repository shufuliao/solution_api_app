require 'rails_helper'

RSpec.describe OrderService, type: :service do
  let(:valid_order) do
    {
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
  end

  describe '#valid?' do
    context 'with valid order' do
      it 'returns true' do
        order_service = OrderService.new(valid_order)
        expect(order_service.valid?).to be true
      end
    end

    context 'with invalid order' do
      it 'returns false when name include non-English characters' do
        valid_order[:name] = 'John Doe1'
        order_service = OrderService.new(valid_order)
        expect { order_service.valid? }.to raise_error('Name contains non-English characters')
      end

      it 'returns false when name is not capitalized' do
        valid_order[:name] = 'John doe'
        order_service = OrderService.new(valid_order)
        expect { order_service.valid? }.to raise_error('Name is not capitalized')
      end

      it 'returns false when price is over 2000' do
        valid_order[:price] = '2001'
        order_service = OrderService.new(valid_order)
        expect { order_service.valid? }.to raise_error('Price is over 2000')
      end

      it 'returns false when currency format is wrong' do
        valid_order[:currency] = 'JPY'
        order_service = OrderService.new(valid_order)
        expect { order_service.valid? }.to raise_error('Currency format is wrong')
      end
    end
  end

  describe '#transform_currency' do
    it 'transforms USD to TWD and updates the price' do
      order_service = OrderService.new(valid_order)
      order_service.transform_currency
      expect(valid_order[:price].to_i).to eq(31000)
      expect(valid_order[:currency]).to eq('TWD')
    end

    it 'does not transform when currency is TWD' do
      valid_order[:currency] = 'TWD'
      order_service = OrderService.new(valid_order)
      order_service.transform_currency
      expect(valid_order[:price].to_i).to eq(1000)
      expect(valid_order[:currency]).to eq('TWD')
    end
  end
end
