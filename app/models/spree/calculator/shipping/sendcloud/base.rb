require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Sendcloud
      class Base < Spree::Calculator::Shipping::ActiveShipping::Base
        preference :api_key, :string
        preference :api_secret, :string

        def carrier
          carrier_details = {
              api_key: self.get_preference(:api_key),
              api_secret: self.get_preference(:api_secret)
          }

          ActiveMerchant::Shipping::SendCloud.new(carrier_details)
        end

        def create_shipment(shipment)
          order = shipment.order
          ship_address = order.ship_address
          address = ::Sendcloud::ShipmentAddress.new(
              ship_address.address1,
              ship_address.city,
              ship_address.zipcode,
              ship_address.country.iso
          )

          shipment_hash = { name: self.class.description, option: [] }
          parcel = carrier.create_shipment(nil, nil, shipment_hash, shipment_address: address, name: ship_address.full_name)

          shipment.sendcloud_parcel_id = parcel['id']
          shipment.print_link = parcel['label']['label_printer']
          shipment.tracking = parcel['tracking_number']
          shipment.save!
        end
      end
    end
  end
end
