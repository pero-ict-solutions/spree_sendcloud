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
      end
    end
  end
end