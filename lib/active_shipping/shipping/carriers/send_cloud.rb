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
        sc_sm = Sendcloud::ShippingMethod.new(@options[:api_key], @options[:api_secret])
        success = true
        response = []
        sc_sm.list.each do |shipping_method|
          if (shipping_method['countries'].any?{|c| c['iso_2'] == origin.country_code} &&
              shipping_method['countries'].any?{|c| c['iso_2'] == destination.country_code})
            country_price = 0
            shipping_method['countries'].each {|c| country_price = c['price'] if c['iso_2'] == destination.country_code}
              response << RateEstimate.new(origin, destination, @@name,
                                          self.class.name,
                                          service_code: shipping_method['name'],
                                          total_price: country_price,
                                          currency: 'EUR',
                                          packages: packages,
                                          delivery_range: {}
              )
          end
        end
        if response.empty?
          success = false
          message = 'No shipping rates could be found for the destination address' if message.blank?
        end
        RateResponse.new(success, message, {}, rates: response)
      end

      def create_shipment(origin, destination, packages, options = {})
        sc_pr = Sendcloud::ParcelResource.new(@options[:api_key], @options[:api_secret])
        sc_pr.create_parcel(options['name'], destination, {id: packages['id'], name: packages['name']})
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

      # private
      #   def sendcloud_auth(class_name)
      #
      #     Sendcloud::Base.new(@options[:api_key], @options[:api_secret])
      #   end
    end
  end
end