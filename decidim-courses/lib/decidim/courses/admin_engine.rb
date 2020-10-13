# frozen_string_literal: true

module Decidim
  module Courses
    # This is the engine that runs on the public interface of `Courses`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Courses::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :courses, param: :slug, except: [:show, :destroy]
      end

      initializer "decidim_courses.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t("menu.courses", scope: "decidim.admin"),
                    decidim_admin_courses.courses_path,
                    icon_name: "book",
                    position: 3.5,
                    active: :inclusive
                    # TODO: if: allowed_to?(:enter, :space_area, space_name: :courses)
        end
      end

      def load_seed
        nil
      end
    end
  end
end
