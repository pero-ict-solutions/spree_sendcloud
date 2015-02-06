# require 'spec_helper'
#
# module ActiveMerchant
#   describe ActiveShipping::Shipping::Carrier::SendCloud do
#     let!(:location) do
#       {
#           country_code: 'NL',
#           city: 'Eindhoven',
#           address: 'Torenallee',
#           postal_code: '5617BC',
#           phone: ''
#       }
#     end
#
#     context 'Sendcloud' do
#       context 'find rates' do
#         it 'with valid params' do
#           response = SendCloud.find_rates(location, location, nil)
#           expect(response).not_to be_empty
#         end
#       end
#     end
#   end
# end
