require_dependency 'spree/calculator'

module Spree
  module Calculator::Shipping
    module Sendcloud
      class VerzekerdVerzenden < Spree::Calculator::Shipping::Sendcloud::Base
        def self.description
          I18n.t("sendcloud.verzekerd_verzenden")
        end
      end
    end
  end
end