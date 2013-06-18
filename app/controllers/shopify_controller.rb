class ShopifyController < ApplicationController
	skip_before_filter :authenticate

	def order_create
		update_list
	end

	def order_cancel
		update_list
	end

	private
	def update_list
		checkout = params
		list = checkout.line_item.map { |x| x.product_id }
		list.uniq!

		list.each do |shopify_id|
			update_product shopify_id
		end
	end

	def update_product shopify_id
		p = ShopifyAPI::Product.find shopify_id
		sizes = {}
		p.variants.each do |x| 
			sizes[x.title] = x.inventory_quantity
		end
		product = Product.where("shopify_id = #{shopify_id}")[0]
		product.sizes = sizes.to_json
		product.save
	end
end