class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  def index
    user = current_user.user_info    
    @products = user.products
    if user.admin
      @products = Product.all 
      @admin = true
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show    
    user = current_user.user_info
    product = user.products.find(params[:id]) if !user.admin
    product = Product.find(params[:id]) if user.admin
    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render json: @product }
    # end
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
    if user_info.admin
      user_info = UserInfo.find params[:product][:user_id].to_i
      params[:product].delete :user_id
    end

    @product = Product.new(params[:product])        
    respond_to do |format|
      if @product.save
        user_info.products.push @product
        Shopify.create @product
        format.html { redirect_to :action => 'index' }
        format.json { render json: @product, status: :created, location: @product }
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
    product = Product.find(params[:id]) if user.admin
    (5-product.photos.count).times { product.photos.build }
    
    remove_empty_image params[:product][:photos_attributes]

    respond_to do |format|
      if product.update_attributes(params[:product])
        product.photos.delete_if { |x| x.photo_file_name == nil }
        puts product.photos
        product.save
        Shopify.modify product
        format.html { redirect_to :action => 'index' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: product.errors, status: :unprocessable_entity }
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
    redirect_to "/" if !user.admin
    @products = UserInfo.find(params[:id]).products
    @admin = true
    render :action => "index"
  end

  private
  def remove_empty_image list
    #remove empty pictures
    list.each do |x|
      begin
        list.delete x[0] if x[1]["photo"] == ""
      rescue
        #nothting
      end
    end
  end
end
