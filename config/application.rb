require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pechico
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.time_zone = 'Tokyo'

    # TODO: :localにするとGroupdateでエラーになる
    #config.active_record.default_timezone = :local

    # config.eager_load_paths << Rails.root.join("extras")

    config.x.app_setting = config_for(:app_setting).deep_symbolize_keys

    config.i18n.default_locale = :ja
  end
end
