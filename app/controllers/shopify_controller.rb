class ShopifyController < ApplicationController
	skip_before_filter :authenticate

	def check_out_create
		checkout = params
		list = checkout.line_item.map { |x| x.product_id }
		list.uniq!

		list.each do |shopify_id|
			p = Product.where "shopify_id = #{shopify_id}"
			sizes = {}
			p.variants.each do |x| 
				sizes[title] = x.inventory_quantity
			end
			p.sizes = sizes.to_s
			p.save
		end
	end


end
