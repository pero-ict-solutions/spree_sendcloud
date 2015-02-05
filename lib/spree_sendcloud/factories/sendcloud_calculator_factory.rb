FactoryGirl.define do
  factory :sendcloud_calculator, class: Spree::Calculator::Shipping::Sendcloud::PakketNederland do
    preferences Hash.new(api_key: 'API_KEY', api_secret: 'API_SECRET')
  end
end
