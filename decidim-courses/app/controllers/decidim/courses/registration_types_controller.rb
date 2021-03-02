# frozen_string_literal: true

module Decidim
  module Courses
    class RegistrationTypesController < Decidim::Courses::ApplicationController
      include ParticipatorySpaceContext

      participatory_space_layout only: :index

      helper_method :collection, :course

      def index
        raise ActionController::RoutingError, "No registration types for this course" if registration_types.empty?

        enforce_permission_to :list, :registration_types
        redirect_to decidim_courses.course_path(current_participatory_space) unless current_user_can_visit_space?
      end

      private

      def registration_types
        @registration_types ||= current_participatory_space.registration_types.published
      end

      alias collection registration_types

      def current_participatory_space
        return unless params[:course_slug]

        @current_participatory_space ||= Course.where(slug: params[:course_slug]).or(
          Course.where(id: params[:course_slug])
        ).first!
      end

      def course
        current_participatory_space
      end
    end
  end
end
