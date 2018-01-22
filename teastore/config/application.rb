require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Teastore
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # CONFIGURATION 'BELONGS_TO()' METHOD
    #   By default, Rails require a value to the column
    #   created by method belongs_to().
    #
    # With this command, we remove this configuration.
    Rails.application.config.active_record.belongs_to_required_by_default = false
  end
end
