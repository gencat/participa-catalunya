# frozen_string_literal: true

Decidim.register_participatory_space(:resource_banks) do |participatory_space|
  participatory_space.icon = "decidim/resource_banks/icon.svg"
  participatory_space.model_class_name = "Decidim::ResourceBank"

  participatory_space.participatory_spaces do |organization|
    Decidim::ResourceBank.where(organization: organization)
  end

  participatory_space.permissions_class_name = "Decidim::ResourceBanks::Permissions"

  # participatory_space.query_type = "Decidim::ResourceBanks::ResourceBankType"

  participatory_space.register_resource(:resource_bank) do |resource|
    resource.model_class_name = "Decidim::ResourceBank"
    # resource.card = "decidim/resource_banks/resource_bank"
    # resource.searchable = true
  end

  participatory_space.context(:public) do |context|
    context.engine = Decidim::ResourceBanks::Engine
    # context.layout = "layouts/decidim/resource_bank"
  end

  participatory_space.context(:admin) do |context|
    context.engine = Decidim::ResourceBanks::AdminEngine
    context.layout = "layouts/decidim/admin/resource_bank"
  end

  participatory_space.register_on_destroy_account do |user|
    # TODO
  end

  participatory_space.seeds do
    organization = Decidim::Organization.first
    seeds_root = File.join(__dir__, "..", "..", "..", "db", "seeds")

    2.times do |n|
      params = {
        title: Decidim::Faker::Localized.sentence(5),
        slug: Faker::Internet.unique.slug(nil, "-"),
        hashtag: "##{Faker::Lorem.word}",
        text: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
          Decidim::Faker::Localized.paragraph(3)
        end,
        video: Faker::Lorem.word,
        promoted: true,
        hero_image: File.new(File.join(seeds_root, "city.jpeg")),
        banner_image: File.new(File.join(seeds_root, "city2.jpeg")),
        published_at: 2.weeks.ago,
        organization: organization,
        authorship: Faker::Name.name,
        created_at: 1.day.from_now,
      }

      resource_bank = Decidim.traceability.perform_action!(
        "publish",
        Decidim::ResourceBank,
        organization.users.first,
        visibility: "all"
      ) do
        Decidim::ResourceBank.create!(params)
      end

      [resource_bank].each do |current_bank|
        current_bank.add_to_index_as_search_resource
        attachment_collection = Decidim::AttachmentCollection.create!(
          name: Decidim::Faker::Localized.word,
          description: Decidim::Faker::Localized.sentence(5),
          collection_for: current_bank
        )

        Decidim::Attachment.create!(
          title: Decidim::Faker::Localized.sentence(2),
          description: Decidim::Faker::Localized.sentence(5),
          file: File.new(File.join(seeds_root, "Exampledocument.pdf")),
          attachment_collection: attachment_collection,
          attached_to: current_bank
        )

        Decidim::Attachment.create!(
          title: Decidim::Faker::Localized.sentence(2),
          description: Decidim::Faker::Localized.sentence(5),
          file: File.new(File.join(seeds_root, "city.jpeg")),
          attached_to: current_bank
        )

        Decidim::Attachment.create!(
          title: Decidim::Faker::Localized.sentence(2),
          description: Decidim::Faker::Localized.sentence(5),
          file: File.new(File.join(seeds_root, "Exampledocument.pdf")),
          attached_to: current_bank
        )

        2.times do
          Decidim::Category.create!(
            name: Decidim::Faker::Localized.sentence(5),
            description: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
              Decidim::Faker::Localized.paragraph(3)
            end,
            participatory_space: current_bank
          )
        end
      end
    end
  end
end
