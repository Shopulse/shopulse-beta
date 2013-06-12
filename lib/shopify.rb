class Shopify
	
	def self.collection_add product
		collection_delete product
		#women => 9872481
		#men => 9872477
		c_id = 9872477 if product.product_type.split("_")[0] == "Men"
		c_id = 9872481 if product.product_type.split("_")[0] == "Women"

		ShopifyAPI::Collect.create({
			:collection_id => c_id,
			:product_id => product.shopify_id,
			:sort_value => product.brand + " - " + product.name,
		})
	end

	def self.collection_delete product
		#this needs to be improved
		product.shopify_id = product.shopify_id.to_i
		list = ShopifyAPI::Collect.all.select { |x| x.product_id == product.shopify_id.to_i }
		
		list.each do |x|
			x.destroy
		end
	end

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
			:product_type => product.product_type.split("_").last,
			:tags => product.product_type.split("_").join(", ")
		})		
		product.shopify_id = p.id
		product.save
		
		#add to collection
		collection_add product

		puts p.errors.messages if p.errors.messages != nil
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
			:product_type => product.product_type.split("_").last,
			:tags => product.product_type.split("_").join(", ")
		})		
		puts p.errors.messages if p.errors.messages != nil
		p.save

		#add to collection
		collection_add product
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
			var[:price] = product.sale_price * 1.029
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