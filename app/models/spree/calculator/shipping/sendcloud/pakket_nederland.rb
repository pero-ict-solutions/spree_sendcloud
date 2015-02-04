require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Sendcloud
      class PakketNederland < Spree::Calculator::Shipping::Sendcloud::Base
        def self.description
          I18n.t("sendcloud.pakket_nederland")
        end
      end
    end
  end
end
