FactoryGirl.define do
  factory :sendcloud_shipping_method, class: Spree::ShippingMethod do
    zones { |a| [Spree::Zone.global] }
    name 'Pakket Nederland (PostNL)'
    code 'Pakket Nederland (PostNL)'

    before(:create) do |shipping_method, evaluator|
      if shipping_method.shipping_categories.empty?
        shipping_method.shipping_categories << (Spree::ShippingCategory.first || create(:shipping_category))
      end
    end

    association(:calculator, factory: :sendcloud_calculator, strategy: :create)
  end
end
