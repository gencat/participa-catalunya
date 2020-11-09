# frozen_string_literal: true

module Decidim
  module ResourceBanks
    # This is the engine that runs on the public interface of `ResourceBank`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::ResourceBanks::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :resource_bank do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "resource_bank#index"
      end

      def load_seed
        nil
      end
    end
  end
end
