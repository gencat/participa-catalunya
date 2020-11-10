# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Courses
    # This is the engine that runs on the public interface of courses.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Courses

      routes do
        resources :courses, only: [:index, :show], param: :slug, path: "courses"
      end

      initializer "decidim_courses.assets" do |app|
        app.config.assets.precompile += %w(decidim_courses_manifest.js decidim_courses_manifest.css)
      end

      initializer "decidim_courses.menu" do
        Decidim.menu :menu do |menu|
          menu.item I18n.t("menu.courses", scope: "decidim"),
                    decidim_courses.courses_path,
                    position: 3.5,
                    if: Decidim::Course.where(organization: current_organization).published.any?,
                    active: :inclusive
        end
      end
    end
  end
end
