# frozen_string_literal: true

module Decidim
  module Courses
    # This is the engine that runs on the public interface of `Courses`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Courses::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :courses, param: :slug, except: [:show, :destroy] do
          resource :publish, controller: "course_publications", only: [:create, :destroy]

          resources :user_roles, controller: "course_user_roles" do
            member do
              post :resend_invitation, to: "course_user_roles#resend_invitation"
            end
          end

          resources :registration_types, controller: "registration_types" do
            resource :publish, controller: "registration_type_publications", only: [:create, :destroy]
          end
          resources :course_invites, only: [:index, :new, :create]
          resources :course_registrations, only: :index do
            member do
              post :confirm
            end
            collection do
              get :export
            end
          end

          resources :attachment_collections, controller: "course_attachment_collections"
          resources :attachments, controller: "course_attachments"
          resource :export, controller: "course_exports", only: :create
          collection do
            get :export
          end
        end
      end

      initializer "decidim_courses.admin_assets" do |app|
        app.config.assets.precompile += %w(admin/decidim_courses_manifest.js)
      end

      initializer "decidim_courses.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t("menu.courses", scope: "decidim.admin"),
                    decidim_admin_courses.courses_path,
                    icon_name: "book",
                    position: 3.5,
                    active: :inclusive,
                    if: allowed_to?(:enter, :space_area, space_name: :courses)
        end
      end

      def load_seed
        nil
      end
    end
  end
end
