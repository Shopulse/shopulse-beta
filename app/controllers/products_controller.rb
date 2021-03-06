class ProductsController < ApplicationController

	private
	def valid_url uri
		!!URI.parse(uri)
	rescue URI::InvalidURIError
		false
	end

	# GET /products
	# GET /products.json
	public
	def index
		current_user.create_user_info if current_user.user_info == nil
		user = current_user.user_info
		@products = user.products

		redirect = false
		if @products
			@products.each do |p|
				if !p.complete_product?
					if valid_url(request.referer) && URI(request.referer).path != '/products/uncomplete_product_list'
						redirect = true
						redirect_to action: "uncomplete_product_list" 
					end
					break
				end
			end
		end

		if user.admin
			@products = Product.all 
			@admin = true
		end

		if redirect == false
			respond_to do |format|
				format.html # index.html.erb
				format.json { render json: @products }
			end
		end
	end

	def uncomplete_product_list
		user = current_user.user_info 
		@products = user.products.select { |x| !x.complete_product? }

		respond_to do |format|
			format.html
		end
	end

	# GET /products/1
	# GET /products/1.json
	def show    
		user = current_user.user_info
		product = user.products.find(params[:id]) if !user.admin
		product = Product.find(params[:id]) if user.admin
		p = ShopifyAPI::Product.find product.shopify_id
		redirect_to 'http://shopulse.myshopify.com/products/'+p.handle
	end

	# GET /products/new
	# GET /products/new.json
	def new
		@product = Product.new
		5.times { @product.photos.build }
		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @product }
		end    
	end

	# GET /products/1/edit
	def edit
		user = current_user.user_info
		@product = user.products.find(params[:id]) if !user.admin
		@product = Product.find(params[:id]) if user.admin
		photo_count = @product.photos.count

		(5-photo_count).times { @product.photos.build }
		@product.photos.each do |x|      
			x.destroy if x.photo_file_name == nil
			puts @product.photos.count
		end
	end

	# POST /products
	# POST /products.json
	def create
		remove_empty_image params[:product][:photos_attributes]

		user_info = current_user.user_info
		admin = false
		if user_info.admin
			user_info = UserInfo.find params[:product][:user_id].to_i
			params[:product].delete :user_id
			admin = true
		end

		@product = Product.new(params[:product])        
		respond_to do |format|
			if @product.save
				user_info.products.push @product
				Shopify.create @product if @product.complete_product?
				if admin == true
					format.html { redirect_to :action => 'retailer', :id => user_info.id }  
				else          
					format.html { redirect_to :action => 'index' }
				end				
			else
				format.html { render action: "new" }
				format.json { render json: @product.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /products/1
	# PUT /products/1.json
	def update
		user = current_user.user_info
		product = user.products.find(params[:id]) if !user.admin
		if user.admin
			product = Product.find(params[:id]) 
			params[:product].delete :user_id
		end
		(5-product.photos.count).times { product.photos.build }

		remove_empty_image params[:product][:photos_attributes]

		respond_to do |format|
			if product.update_attributes(params[:product])
				product.photos.delete_if { |x| x.photo_file_name == nil }
				product.save

				if product.shopify_id == nil && product.complete_product? == true
					puts "create Shopify Product " + product.id.to_s
					Shopify.create product
				elsif product.shopify_id != nil && Shopify.modify(product)
					puts "modified Shopify Product " + product.id.to_s
					format.html { render action: "index" }
				else
					format.html { render action: "index" }
					format.json { render json: product.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	# DELETE /products/1
	# DELETE /products/1.json
	def destroy    
		user = current_user.user_info
		product = user.products.find(params[:id]) if !user.admin
		product = Product.find(params[:id]) if user.admin
		Shopify.delete product
		product.destroy
		respond_to do |format|
			format.html { redirect_to products_url }
			format.json { head :no_content }
		end
	end

	def retailer
		user = current_user.user_info
		redirect_to "/" if user.admin != true
		@products = UserInfo.find(params[:id]).products
		@admin = true
		render :index
	end
	
	def remove_empty_image list
		#remove empty pictures
		list.each do |x|
			begin
				list.delete x[0] if x[1]["photo"] == ""
			rescue
				puts "error"
				puts list
			end
		end
	end
end
