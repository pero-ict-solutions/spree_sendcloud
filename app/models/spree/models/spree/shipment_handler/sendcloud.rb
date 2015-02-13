module Spree
  class ShipmentHandler
    class SendCloud < ShipmentHandler
      def perform
        super if @shipment.shipping_method.calculator.create_shipment(@shipment)
      end
    end
  end
end