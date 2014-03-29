require File.expand_path('../boot', __FILE__)

require 'rails/all'
# require 'voteable_matt_dec' #this is the gem I'd created

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module PostitTemplate
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/lib) #it is an array(one element in this case); 'config.root' is the application root folder and 'lib' is the folder
            #When Rails boots up, it looks in 'application.rb'(here) first; it will know to go to the lib folder to look for 'voteable.rb' which contains the 'Voteable' module; when 'include Voteable' is invoked in the model, it knows to go here to look for the Voteable module.


    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Bangkok'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Tealeaf note: Bootstrap sass gem addition
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
  end
end
