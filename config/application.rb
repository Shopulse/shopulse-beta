require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module ShopulseBeta
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    # config.active_record.whitelist_attributes = true

    #Heroku
    config.assets.initialize_on_precompile = false
    config.assets.compile = true

    # Enable the asset pipeline    
    config.assets.enabled = true
    # config.assets.initialize_on_precompile = false

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # ShopifyAPI::Session.setup({:api_key => '0098423aae3673520d1b3aa3139d7323', :secret => 'b1072969b6cdd1d0e37503be3dec59c5'})
    ShopifyAPI::Base.site = "https://0098423aae3673520d1b3aa3139d7323:b1072969b6cdd1d0e37503be3dec59c5@shopulse.myshopify.com/admin"
    
    #lib
    config.cache_classes = true   
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]  

    #Paperclip
    config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => 'ggmichaelgo',
      :access_key_id => 'AKIAJ4DCD2FAZNJFIO5A',
      :secret_access_key => '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'
    }

  end
end
