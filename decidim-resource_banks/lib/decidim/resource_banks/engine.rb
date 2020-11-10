# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module ResourceBanks
    # This is the engine that runs on the public interface of resource_banks.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::ResourceBanks

      routes do
        # Add engine routes here
        # resources :resource_bank
        # root to: "resource_bank#index"
      end

      initializer "decidim_resource_banks.assets" do |app|
        app.config.assets.precompile += %w[decidim_resource_banks_manifest.js decidim_resource_banks_manifest.css]
      end
    end
  end
end
