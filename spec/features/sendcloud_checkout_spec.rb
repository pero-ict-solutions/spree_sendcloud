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

  def click_edit_order
    within 'table#listing_orders' do
      find('.action-edit').click
    end
  end


  context 'User goes to delivery step and able to choose Pakket Nederland (PostNL)' do
    before do
      VCR.use_cassette 'sendcloud api call' do
        prepare_order_for_delivery
        wait_for_ajax
        expect(page).to have_content("Pakket Nederland (PostNL)")
      end
    end

    describe 'and completes checkout. ' do
      before do
        click_button "Save and Continue"
        # Payment step doesn't require any action
        click_button "Save and Continue"
        expect(page).to have_content("Your order has been processed successfully")
        expect(Spree::Order.first.shipments.last.shipping_method.name).to eql 'Pakket Nederland (PostNL)'
      end

      context 'Admin visits shipments page' do
        stub_authorization!
        before do
          visit spree.admin_path
          click_link "Orders"

          expect(page).to have_selector('table#listing_orders tbody tr', :count => 1)
        end

        it 'and able to ship package if it is paid.' do
          ActiveRecord::Base.transaction do
            Spree::Shipment.last.inventory_units.each &:fill_backorder!
            Spree::Payment.last.complete!
          end
          click_edit_order
          wait_for_ajax

          VCR.use_cassette 'sendcloud ship call' do
            page.find('a.ship').click
            wait_for_ajax
          end

          expect(page).to have_content('Sendcloud parcel id')
          expect(page).to have_content('Link to print label(Not for public use)')
        end

        it 'and cannot see ship button if it is not paid.' do
          click_edit_order

          expect(page).not_to have_selector("a.ship.btn")
        end
      end
    end
  end
end
