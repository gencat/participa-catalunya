# frozen_string_literal: true

Decidim.register_participatory_space(:courses) do |participatory_space|
  participatory_space.icon = "decidim/courses/icon.svg"
  participatory_space.model_class_name = "Decidim::Courses::Course"

  participatory_space.participatory_spaces do |organization|
    Decidim::Courses::OrganizationCourses.new(organization).query
  end

  participatory_space.permissions_class_name = "Decidim::Courses::Permissions"

  # participatory_space.query_type = "Decidim::Courses::CourseType"

  participatory_space.register_resource(:course) do |resource|
    resource.model_class_name = "Decidim::Courses::Course"
    # resource.card = "decidim/courses/course"
    # resource.searchable = true
  end

  participatory_space.context(:public) do |context|
    context.engine = Decidim::Courses::Engine
    # context.layout = "layouts/decidim/course"
  end

  participatory_space.context(:admin) do |context|
    context.engine = Decidim::Courses::AdminEngine
    # context.layout = "layouts/decidim/admin/course"
  end

  participatory_space.exports :assemblies do |export|
    export.collection do |course|
      Decidim::Courses::Course.where(id: course.id)
    end

    export.serializer Decidim::Courses::CourseSerializer
  end

  participatory_space.register_on_destroy_account do |user|
    # TODO
  end

  participatory_space.seeds do
    # TODO
  end
end
