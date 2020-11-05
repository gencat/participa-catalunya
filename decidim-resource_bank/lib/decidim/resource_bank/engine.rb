# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module ResourceBank
    # This is the engine that runs on the public interface of resource_bank.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::ResourceBank

      routes do
        # Add engine routes here
        # resources :resource_bank
        # root to: "resource_bank#index"
      end

      initializer "decidim_resource_bank.assets" do |app|
        app.config.assets.precompile += %w[decidim_resource_bank_manifest.js decidim_resource_bank_manifest.css]
      end
    end
  end
end
