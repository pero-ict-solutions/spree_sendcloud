require 'spec_helper'

describe "SendCloud Shipping Method", js: true do
  stub_authorization!

  context "Admin" do
    before(:each) do
      visit spree.admin_path
    end

    describe "can configure a shipping method: " do
      before(:each) do
        Spree::ShippingCategory.create!(name: 'My category')

        click_link 'Configuration'
        click_link 'Shipping Methods'
      end

      it "should be able to create a new shipping method and set api key for it" do
        click_link 'admin_new_shipping_method_link'
        expect(page).to have_content("New Shipping Method ")
        fill_in "shipping_method_name", with: "PostNL Nederland"
        within(".categories"){ check('My category') }
        select "PostNL Nederland", from: "calc_type"
        click_button "Create"
        expect(page).to have_content("successfully created!")

        wait_for_ajax
        fill_in "shipping_method_calculator_attributes_preferred_api_key", with: "My key"
        fill_in "shipping_method_calculator_attributes_preferred_api_secret", with: "My secret"
        click_button "Update"
        wait_for_ajax
        expect(page).to have_content("successfully updated!")
        expect(find_field("shipping_method_calculator_attributes_preferred_api_key").value).to eql "My key"
        expect(find_field("shipping_method_calculator_attributes_preferred_api_secret").value).to eql "My secret"
        expect(Spree::ShippingMethod.last.calculator.get_preference(:api_key)).to eql "My key"
        expect(Spree::ShippingMethod.last.calculator.get_preference(:api_secret)).to eql "My secret"
      end
    end
  end
end
