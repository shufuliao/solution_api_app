class OrderService
  def initialize(order)
    order[:price] = order[:price].to_i
    @order = order
  end

  def valid?
    validate_price
    validate_name
    validate_currency

    true
  end

  def transform_currency
    if @order[:currency] == 'USD'
      @order[:price] = (@order[:price] * 31).to_s
      @order[:currency] = 'TWD'
    end
  end

  private

  def validate_name
    name = @order[:name]

    if name.match?(/[^a-zA-Z ]/)
      raise 'Name contains non-English characters'
    elsif !name.match?(/\A([A-Z][a-z]*)( [A-Z][a-z]*)*\z/)
      raise 'Name is not capitalized'
    end
  end

  def validate_price
    raise 'Price is over 2000' if @order[:price] > 2000
  end

  def validate_currency
    raise 'Currency format is wrong' if %w[TWD USD].exclude?(@order[:currency])
  end
end
