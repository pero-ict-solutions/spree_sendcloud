require 'spec_helper'

describe SpreeSendcloud::SendCloud do
  let!(:location) do
    {
        country_code: 'NL',
        city: 'Eindhoven',
        address: 'Torenallee',
        postal_code: '5617BC',
        phone: ''
    }
  end

  context 'Sendcloud' do
    context 'find rates' do
      it 'with valid params' do
        response = SpreeSendcloud::SendCloud.find_rates(location, location, nil)
        expect(response).not_to be_empty
      end
    end
  end
end