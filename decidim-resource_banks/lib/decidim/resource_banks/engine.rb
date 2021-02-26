# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module ResourceBanks
    # This is the engine that runs on the public interface of resource_banks.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::ResourceBanks

      routes do
        resources :resource_banks, only: [:index, :show], param: :slug, path: "resource-banks"
      end

      initializer "decidim_resource_banks.assets" do |app|
        app.config.assets.precompile += %w(decidim_resource_banks_manifest.js decidim_resource_banks_manifest.css)
      end

      initializer "decidim_resource_banks.menu" do
        Decidim.menu :menu do |menu|
          menu.item I18n.t("menu.resource_banks", scope: "decidim"),
                    decidim_resource_banks.resource_banks_path,
                    position: 2.3,
                    if: Decidim::ResourceBank.where(organization: current_organization).published.any?,
                    active: :inclusive
        end
      end

      initializer "decidim.stats" do
        Decidim.stats.register :resource_banks_count, priority: StatsRegistry::HIGH_PRIORITY do |organization, _start_at, _end_at|
          Decidim::ResourceBank.where(organization: organization).published.count
        end
      end
    end
  end
end
