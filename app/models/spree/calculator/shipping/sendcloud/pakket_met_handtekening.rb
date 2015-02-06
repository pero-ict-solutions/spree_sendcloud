require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Sendcloud
      class PakketMetHandtekening < Spree::Calculator::Shipping::Sendcloud::Base
        def self.description
          I18n.t("sendcloud.pakket_met_handtekening")
        end
      end
    end
  end
end
