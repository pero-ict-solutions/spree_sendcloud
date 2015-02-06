module SpreeSendcloud
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_sendcloud'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir[File.join(File.dirname(__FILE__), "../../app/models/spree/calculator/**/base.rb")].sort.each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), '../../app/models/**/*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), '../../lib/active_shipping/shipping/carriers/*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc

    initializer "spree_sendcloud.register.calculators" do |app|
      if app.config.spree.calculators.shipping_methods
        classes = Dir.chdir File.join(File.dirname(__FILE__), "../../app/models") do
          Dir["spree/calculator/**/*.rb"].reject {|path| path =~ /base.rb$/ }.map do |path|
            path.gsub('.rb', '').camelize.constantize
          end
        end

        app.config.spree.calculators.shipping_methods.concat classes
      end
    end

    initializer "spree_sendcloud.redefine_shipment_handler" do |app|
      Spree::ShipmentHandler.class_eval do
        class << self
          def factory_with_check_base(shipment)
            if shipment.shipping_method.calculator.kind_of?(Spree::Calculator::Shipping::Sendcloud::Base)
              Spree::ShipmentHandler::SendCloud.new(shipment)
            else
              factory_without_check_base(shipment)
            end
          end

          alias_method_chain :factory, :check_base
        end
      end
    end
  end
end
