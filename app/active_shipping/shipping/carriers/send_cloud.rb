require 'active_shipping'
require 'sendcloud'

module ActiveMerchant
  module Shipping
    class SendCloud < Carrier
      self.retry_safe = true
      cattr_reader :name

      @@name = 'Sendcloud'

      def requirements
        [:api_key, :api_secret]
      end

      def find_rates(origin, destination, packages, options = {})
        options = @options.update(options)
        packages = packages
        build_rate_request(origin, destination)
      end

      def create_shipment(origin, destination, packages, options = {})
        sendcloud_auth
        Sendcloud::ParcelResource.create_parcel(options['name'], destination, {id: packages['id'], name: packages['name']})
      end

      def maximum_weight
        Mass.new(30, :kilograms)
      end

      def self.default_location
        Location.new( :country => 'NL',
                      :city => 'Eindhoven',
                      :address => 'Torenallee',
                      :postal_code => '5617BC',
                      :phone => '')
      end

      private
        def sendcloud_auth
          auth = Sendcloud::Base.new(@options[:api_key], @options[:api_secret])
          auth
        end

        def build_rate_request(origin, destination)
          sendcloud_auth
          request = []
          Sendcloud::ShippingMethod.list.each do |shipping_method|
            if shipping_method['countries'].include?(origin.country) &&
                shipping_method['countries'].include?(destination.country)
              request << Hash.new(id: shipping_method['id'],
                                name: shipping_method['name'],
                                price: country['price']
              )
            end
          end
          request
        end
    end
  end
end