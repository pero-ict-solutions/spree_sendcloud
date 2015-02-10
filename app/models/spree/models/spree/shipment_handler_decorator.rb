Spree::ShipmentHandler.class_eval do
  class << self
    def factory_with_check_base(shipment)
      if shipment.shipping_method.calculator.kind_of?(Spree::Calculator::Shipping::Sendcloud::Base)
        Spree::ShipmentHandler::SendCloud.new(shipment)
      else
        factory_without_check_base(shipment)
      end
    end

    alias_method_chain :factory, :check_base
  end
end