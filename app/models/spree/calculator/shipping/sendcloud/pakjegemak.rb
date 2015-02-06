require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Sendcloud
      class Pakjegemak < Spree::Calculator::Shipping::Sendcloud::Base
        def self.description
          I18n.t("sendcloud.pakjegemak")
        end
      end
    end
  end
end