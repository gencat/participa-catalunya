# frozen_string_literal: true

Decidim.register_participatory_space(:courses) do |participatory_space|
  participatory_space.icon = "decidim/courses/icon.svg"
  participatory_space.model_class_name = "Decidim::Course"
  participatory_space.stylesheet = "decidim/courses/courses"

  participatory_space.participatory_spaces do |organization|
    Decidim::Course.where(organization: organization)
  end

  participatory_space.permissions_class_name = "Decidim::Courses::Permissions"

  # participatory_space.query_type = "Decidim::Courses::CourseType"

  participatory_space.register_resource(:course) do |resource|
    resource.model_class_name = "Decidim::Course"
    resource.card = "decidim/courses/course"
    resource.searchable = true
  end

  participatory_space.context(:public) do |context|
    context.engine = Decidim::Courses::Engine
    context.layout = "layouts/decidim/course"
  end

  participatory_space.context(:admin) do |context|
    context.engine = Decidim::Courses::AdminEngine
    context.layout = "layouts/decidim/admin/course"
  end

  participatory_space.register_on_destroy_account do |user|
    # TODO
  end

  participatory_space.seeds do
    organization = Decidim::Organization.first
    seeds_root = File.join(__dir__, "..", "..", "..", "db", "seeds")

    Decidim::ContentBlock.create(
      organization: organization,
      weight: 32,
      scope_name: :homepage,
      manifest_name: :upcoming_courses,
      published_at: Time.current
    )

    2.times do |n|
      params = {
        title: Decidim::Faker::Localized.sentence(5),
        slug: Faker::Internet.unique.slug(nil, "-"),
        hashtag: "##{Faker::Lorem.word}",
        description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
          Decidim::Faker::Localized.paragraph(3)
        end,
        organization: organization,
        hero_image: File.new(File.join(seeds_root, "city.jpeg")), # Keep after organization
        banner_image: File.new(File.join(seeds_root, "city2.jpeg")), # Keep after organization
        promoted: true,
        published_at: 2.weeks.ago,
        modality: "online",
        address: Faker::Lorem.word,
        scope: n.positive? ? Decidim::Scope.reorder(Arel.sql("RANDOM()")).first : nil,
        created_at: 1.day.from_now,
        duration: Random.new.rand(100),
        course_date: 2.days.from_now
      }

      course = Decidim.traceability.perform_action!(
        "publish",
        Decidim::Course,
        organization.users.first,
        visibility: "all"
      ) do
        Decidim::Course.create!(params)
      end

      [course].each do |current_course|
        current_course.add_to_index_as_search_resource
        attachment_collection = Decidim::AttachmentCollection.create!(
          name: Decidim::Faker::Localized.word,
          description: Decidim::Faker::Localized.sentence(5),
          collection_for: current_course
        )

        Decidim::Attachment.create!(
          title: Decidim::Faker::Localized.sentence(2),
          description: Decidim::Faker::Localized.sentence(5),
          attached_to: current_course,
          attachment_collection: attachment_collection,
          file: File.new(File.join(seeds_root, "Exampledocument.pdf")) # Keep after attached_to
        )

        Decidim::Attachment.create!(
          title: Decidim::Faker::Localized.sentence(2),
          description: Decidim::Faker::Localized.sentence(5),
          attached_to: current_course,
          file: File.new(File.join(seeds_root, "city.jpeg")) # Keep after attached_to
        )

        Decidim::Attachment.create!(
          title: Decidim::Faker::Localized.sentence(2),
          description: Decidim::Faker::Localized.sentence(5),
          attached_to: current_course,
          file: File.new(File.join(seeds_root, "Exampledocument.pdf")) # Keep after attached_to
        )

        2.times do
          Decidim::Category.create!(
            name: Decidim::Faker::Localized.sentence(5),
            description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
              Decidim::Faker::Localized.paragraph(3)
            end,
            participatory_space: current_course
          )
        end
      end
    end
  end
end
