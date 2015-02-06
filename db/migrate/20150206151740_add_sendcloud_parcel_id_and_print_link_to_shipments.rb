class AddSendcloudParcelIdAndPrintLinkToShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :sendcloud_parcel_id, :integer
    add_column :spree_shipments, :print_link, :text
  end
end
