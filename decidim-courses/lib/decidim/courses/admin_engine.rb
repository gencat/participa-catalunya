# frozen_string_literal: true

module Decidim
  module Courses
    # This is the engine that runs on the public interface of `Courses`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Courses::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :courses do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "courses#index"
      end

      def load_seed
        nil
      end
    end
  end
end
