# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Courses
    # This is the engine that runs on the public interface of courses.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Courses

      routes do
        resources :courses, only: [:index, :show], param: :slug, path: "courses" do
          resources :registration_types, only: :index, path: "registration" do
            resource :course_registration, only: [:create, :destroy] do
              collection do
                get :create
                get :decline_invitation
              end
            end
          end
        end
      end

      initializer "decidim_courses.assets" do |app|
        app.config.assets.precompile += %w(decidim_courses_manifest.js decidim_courses_manifest.css)
      end

      initializer "decidim_courses.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Courses::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Courses::Engine.root}/app/views") # for partials
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

      initializer "decidim_courses.content_blocks" do
        Decidim.content_blocks.register(:homepage, :upcoming_courses) do |content_block|
          content_block.cell = "decidim/courses/content_blocks/upcoming_courses"
          content_block.public_name_key = "decidim.courses.content_blocks.upcoming_courses.name"
        end
      end

      initializer "decidim.stats" do
        Decidim.stats.register :courses_count, priority: StatsRegistry::HIGH_PRIORITY do |organization, _start_at, _end_at|
          Decidim::Course.where(organization: organization).published.count
        end
      end
    end
  end
end
