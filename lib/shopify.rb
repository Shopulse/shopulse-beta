class Shopify

	def self.create product		
		vendor = product.user_info.name
		p = ShopifyAPI::Product.create({ 
			:body_html => product.description.gsub("\r\n", "<br><br>")+"<br>material: " + product.material,
			:title => product.brand + " - " + product.name,
			:handle => (vendor + " " + product.name).gsub(" ","-"),
			:images => product.photos.map { |x| { :src => x = x.photo.url }},
			:variants => self.create_variant(product, vendor),
			:vendor => vendor,
			:taxable => true,
			:requires_shipping => true,
			:inventory_management => "shopify",
			:options => [{ :name => "Size" }],
			:product_type => product.product_type
		})
		product.shopify_id = p.id
		product.save
		return p
	end

	def self.modify product
		vendor = product.user_info.name
		p = ShopifyAPI::Product.find product.shopify_id
		
		var_id_list = []
		p.variants.map { |x| var_id_list.push x.id }

		p.update_attributes ({
			:body_html => product.description.gsub("\r\n", "<br><br>")+"<br>material: " + product.material,
			:title => product.brand + " - " + product.name,
			:handle => (vendor + " " + product.name).gsub(" ","-"),
			:images => product.photos.map { |x| { :src => x = x.photo.url }},
			:variants => self.modify_variant(product, vendor, var_id_list),
			:vendor => vendor,
			:taxable => true,
			:requires_shipping => true,
			:inventory_management => "shopify",
			:options => [{ :name => "Size" }],
			:product_type => product.product_type
		})
		p.save
	end

	def self.delete product
		p = ShopifyAPI::Product.find product.shopify_id
		p.destroy
	end

	private

	def self.create_variant product, vendor
		inventory = JSON.parse(product.sizes)
		var_list = []
		inventory.keys.each do |size|
			var = {}
			var[:option1] = size
			var[:title] = size
			var[:inventory_management] = "shopify"
			var[:inventory_quantity] = inventory[size].to_i
			var[:compare_at_price] = product.price
			var[:price] = product.sale_price
			var[:sku] = vendor+"-"+product.name+"-"+size
			var_list.push var
		end
		return var_list
	end

	def self.modify_variant product, vendor, id_list
		inventory = JSON.parse(product.sizes)
		var_list = []
		id_list.reverse!
		inventory.keys.each do |size|
			var = {}
			var[:id] = id_list.pop
			var[:option1] = size
			var[:title] = size
			var[:inventory_management] = "shopify"
			var[:inventory_quantity] = inventory[size].to_i
			var[:compare_at_price] = product.price
			var[:price] = product.sale_price
			var[:sku] = vendor+"-"+product.name+"-"+size
			var_list.push var
		end
		return var_list
	end
end