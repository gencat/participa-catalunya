# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ParticipaCatalunya
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Custom I18n fallbacks
    config.after_initialize do
      I18n.fallbacks = I18n::Locale::Fallbacks.new(
        {
          ca: [:ca, :es, :en],
          es: [:es, :ca, :en],
          oc: [:oc, :ca, :es, :en]
        }
      )
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
