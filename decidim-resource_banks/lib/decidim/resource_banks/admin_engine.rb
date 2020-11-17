# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # This is the engine that runs on the public interface of `ResourceBanks`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::ResourceBanks::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :resource_banks, param: :slug, except: [:show, :destroy] do
          resource :publish, controller: "resource_bank_publications", only: [:create, :destroy]
        end
      end

      initializer "decidim_resource_banks.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t("menu.resource_banks", scope: "decidim.admin"),
                    decidim_admin_resource_banks.resource_banks_path,
                    icon_name: "globe",
                    position: 3.5,
                    active: :inclusive,
                    if: allowed_to?(:enter, :space_area, space_name: :resource_banks)
        end
      end

      def load_seed
        nil
      end
    end
  end
end
