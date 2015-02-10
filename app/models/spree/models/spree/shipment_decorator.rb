Spree::Shipment.class_eval do
  def print_link_with_auth_params
    uri = URI(print_link)

    begin
      uri.user = shipping_method.calculator.get_preference(:api_key)
      uri.password = shipping_method.calculator.get_preference(:api_secret)
    rescue NoMethodError => e
      logger.error e.message
    end

    uri.to_s
  end

  def is_sendcloud?
    shipping_method.calculator.kind_of? Spree::Calculator::Shipping::Sendcloud::Base
  end
end