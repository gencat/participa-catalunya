# frozen_string_literal: true

module Decidim
  module Courses
    # A controller that holds the logic to show Courses in a public layout.
    class CoursesController < Decidim::Courses::ApplicationController
      include ParticipatorySpaceContext
      include FilterResource
      helper Decidim::ResourceHelper
      helper Decidim::AttachmentsHelper
      helper Decidim::ResourceReferenceHelper
      participatory_space_layout only: :show

      def show
        enforce_permission_to :read, :course, course: current_participatory_space
      end

      private

      def current_participatory_space
        return unless params[:slug]

        @current_participatory_space ||=  Decidim::Course.where(slug: params[:slug], organization: current_organization).first
      end

      def current_participatory_space_manifest
        @current_participatory_space_manifest ||= Decidim.find_participatory_space_manifest(:courses)
      end
    end
  end
end
