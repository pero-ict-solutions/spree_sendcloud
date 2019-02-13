# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_sendcloud'
  s.version     = '3.0.1.beta'
  s.summary     = 'Use Sendcloud shipping for your SpreeCommerce storefront'
  s.description = s.summary
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'PeRo ICT Solutions'
  s.email     = 'info@pero-ict.nl'
  s.homepage  = 'http://www.pero-ict.nl'

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.1.0.beta'
  s.add_dependency 'active_shipping', '0.12.5'
  s.add_dependency 'sendcloud-ruby', '1.0.0'

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'capybara-webkit'
end
