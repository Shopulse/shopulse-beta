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
    @product = user.products.find(params[:id]) if !user.admin
    @product = Product.find(params[:id]) if user.admin    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
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
    @product = current_user.user_info.products.find(params[:id])
    (5-@product.photos.count).times { @product.photos.build }
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])
    respond_to do |format|
      if @product.save
        current_user.user_info.products.push @product
        Shopify.create @product
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
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
    @product = current_user.user_info.products.find(params[:id])
    respond_to do |format|
      if @product.update_attributes(params[:product])
        Shopify.modify @product
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    Shopify.delete @product
    @product = current_user.user_info.products.find(params[:id])
    @product.destroy
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
end
