require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Sendcloud
      class AlleenHuisadres < Spree::Calculator::Shipping::Sendcloud::Base
        def self.description
          I18n.t("sendcloud.alleen_huisadres")
        end
      end
    end
  end
end