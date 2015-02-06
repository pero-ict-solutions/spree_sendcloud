require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Sendcloud
      class PakketNaarBuitenland < Spree::Calculator::Shipping::Sendcloud::Base
        def self.description
          I18n.t("sendcloud.pakket_naar_buitenland")
        end
      end
    end
  end
end
