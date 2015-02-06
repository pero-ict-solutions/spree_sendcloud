require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Sendcloud
      class Brievenpost < Spree::Calculator::Shipping::Sendcloud::Base
        def self.description
          I18n.t("sendcloud.brievenpost")
        end
      end
    end
  end
end