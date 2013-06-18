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
		p = Product.where "shopify_id = #{shopify_id}"
		sizes = {}
		p.variants.each do |x| 
			sizes[title] = x.inventory_quantity
		end
		p.sizes = sizes.to_s
		p.save
	end
end