require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Sendcloud
      class HandtekeningVoorOntvangst < Spree::Calculator::Shipping::Sendcloud::Base
        def self.description
          I18n.t("sendcloud.handtekening_voor_ontvangst")
        end
      end
    end
  end
end
