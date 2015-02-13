require 'spec_helper'

include ActiveMerchant::Shipping
module ActiveMerchant
  describe Shipping::SendCloud do
    before(:each) do
      @location = ActiveMerchant::Shipping::Location.new(
          country: 'Netherlands',
          city: 'Eindhoven',
          address: 'Torenallee',
          postal_code: '5617BC',
          phone: ''
      )
      @fail_location = ActiveMerchant::Shipping::Location.new(
          country: 'Belarus',
          city: 'Minsk',
          address: 'Torenallee',
          postal_code: '5617BC',
          phone: ''
      )
    end

    context 'get' do
      context 'find rates' do
        it 'with valid params' do
          VCR.use_cassette(:find_rate_valid_params) do
            carrier = SendCloud.new(api_key: 'TEST_KEY', api_secret: 'TEST_SECRET')
            response = carrier.find_rates(@location, @location, nil)
            expect(response.rates).not_to be_empty
          end
        end

        it 'with invalid destination' do
          VCR.use_cassette(:find_rate_invalid_destination) do
            carrier = SendCloud.new(api_key: 'TEST_KEY', api_secret: 'TEST_SECRET')
            expect {carrier.find_rates(@location, @fail_location, nil)}.
                to raise_error(ActiveMerchant::Shipping::ResponseError)
          end
        end

        it 'with invalid origin' do
          VCR.use_cassette(:find_rate_invalid_origin) do
            carrier = SendCloud.new(api_key: 'TEST_KEY', api_secret: 'TEST_SECRET')
            expect{carrier.find_rates(@fail_location, @location, nil)}.
                to raise_error(ActiveMerchant::Shipping::ResponseError)
          end
        end
      end
    end

    context 'create' do
      let!(:parcel_options) do
        {
            package_id: 1,
            package_name: 'Pakket Nederland (PostNL)'
        }
      end
      let!(:new_parcel) do
        {
            "name"=>"Rob van den Heuvel",
            "shipment_address" => Sendcloud::ShipmentAddress.new('Torenallee', 'Eindhoven', '5617BC', '')
        }
      end
      it 'with valid params' do
        VCR.use_cassette(:create_shippment_with_valid_params) do
          carrier = SendCloud.new(api_key: 'TEST_KEY', api_secret: 'TEST_SECRET')
          response = carrier.create_shipment(@location, @location,
                                             {id: parcel_options[:package_id],
                                              name: parcel_options[:package_name]},
                                             {name: new_parcel['name'],
                                              shipment_address: new_parcel['shipment_address']}
              )
          expect(response).not_to be_empty
        end
      end
    end
  end
end
