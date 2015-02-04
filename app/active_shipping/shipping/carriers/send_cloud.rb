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
        @options.update(options)
        packages = Array(packages)
        sendcloud_auth
        response = []
        Sendcloud::ShippingMethod.list.each do |shipping_method|
          if (shipping_method['countries'].any?{|c| c['iso_3'] == origin.country_code} &&
              shipping_method['countries'].any?{|c| c['iso_3'] == destination.country_code})
            shipping_method['countries'].each do |country|
              response << RateEstimate.new(origin, destination, @@name,
                                          self.class.name,
                                          service_code: shipping_method['name'],
                                          total_price: country['price'],
                                          currency: 'EUR',
                                          packages: packages,
                                          delivery_range: ''
              )
            end
          end
        end
        if response.empty?
          success = false
          message = 'No shipping rates could be found for the destination address' if message.blank?
        end
        RateResponse.new(success, message, nil, rates: response)
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
    end
  end
end