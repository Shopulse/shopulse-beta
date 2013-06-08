class AddShopifyidToProduct < ActiveRecord::Migration
  def change
    add_column :products, :shopify_id, :string
  end
end
