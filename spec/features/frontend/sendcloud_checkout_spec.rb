require 'spec_helper'

describe "Checkout Order With SendCloud", js: true do

  let!(:product) { create(:product, :name => 'iPad') }
  let!(:calculator) { create(:sendcloud_calculator, preferences: {api_key: 'TEST_KEY', api_secret: 'TEST_SECRET'}) }
  let!(:shipping_method) { create(:sendcloud_shipping_method, name: 'Pakket Nederland (PostNL)', calculator: calculator) }
  let!(:payment_method) { create(:check_payment_method)}

  before do
    country = Spree::Country.last
    country.update!(iso: 'NL', name: 'Netherlands')
    state = Spree::State.last
    state.update!(name: 'Noord-Holland')
    Spree::StockLocation.last.update!(country: country, state: state)
  end

  def fill_in_billing
    within("#billing") do
      fill_in "First Name", :with => "Test"
      fill_in "Last Name", :with => "User"
      fill_in "Street Address", :with => "1 User Lane"
      fill_in "City", :with => "Amsterdam"
      select "Netherlands", :from => "order_bill_address_attributes_country_id"
      select "Noord-Holland", :from => "order_bill_address_attributes_state_id"
      fill_in "Zip", :with => "1051KN"
      fill_in "Phone", :with => "111222333"
    end
  end

  def prepare_order_for_delivery
    visit spree.root_path
    click_link 'iPad'
    click_button 'Add To Cart'
    click_button 'Checkout'
    within("#guest_checkout") do
      fill_in "Email", :with => "test@example.com"
      click_button 'Continue'
    end
    wait_for_ajax
    fill_in_billing
    click_button "Save and Continue"
  end


  context 'User goes to delivery step' do
    before do
      VCR.use_cassette 'sendcloud api call' do
        prepare_order_for_delivery
        wait_for_ajax
      end
    end
    it 'and able to choose Pakket Nederland (PostNL)' do
      expect(page).to have_content("Pakket Nederland (PostNL)")
      click_button "Save and Continue"
      # Payment step doesn't require any action
      click_button "Save and Continue"
      expect(page).to have_content("Your order has been processed successfully")
      expect(Spree::Order.first.shipments.last.shipping_method.name).to eql 'Pakket Nederland (PostNL)'
    end
  end
end
