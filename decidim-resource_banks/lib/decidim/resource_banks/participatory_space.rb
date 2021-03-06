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
    resource.card = "decidim/resource_banks/resource_bank"
    resource.searchable = true
  end

  participatory_space.context(:public) do |context|
    context.engine = Decidim::ResourceBanks::Engine
    context.layout = "layouts/decidim/resource_bank"
  end

  participatory_space.context(:admin) do |context|
    context.engine = Decidim::ResourceBanks::AdminEngine
    context.layout = "layouts/decidim/admin/resource_bank"
  end

  participatory_space.register_on_destroy_account do |user|
    Decidim::ResourceBankUserRole.where(user: user).destroy_all
  end

  participatory_space.seeds do
    organization = Decidim::Organization.first
    seeds_root = File.join(__dir__, "..", "..", "..", "db", "seeds")

    2.times do |n|
      params = {
        announcement: Decidim::Faker::Localized.sentence(5),
        title: Decidim::Faker::Localized.sentence(5),
        slug: Faker::Internet.unique.slug(nil, "-"),
        hashtag: "##{Faker::Lorem.word}",
        text: Decidim::Faker::Localized.wrapped("<p>", "</p>") do
          Decidim::Faker::Localized.paragraph(3)
        end,
        video_url: Faker::Internet.url,
        promoted: true,
        organization: organization,
        hero_image: File.new(File.join(seeds_root, "city.jpeg")), # Keep after organization
        banner_image: File.new(File.join(seeds_root, "city2.jpeg")), # Keep after organization
        published_at: 2.weeks.ago,
        authorship: Faker::Name.name,
        scope: n.positive? ? nil : Decidim::Scope.reorder(Arel.sql("RANDOM()")).first,
        created_at: 1.day.from_now
      }

      resource_bank = Decidim.traceability.perform_action!(
        "publish",
        Decidim::ResourceBank,
        organization.users.first,
        visibility: "all"
      ) do
        Decidim::ResourceBank.create!(params)
      end

      # Create users with specific roles
      Decidim::ResourceBankUserRole::ROLES.each do |role|
        email = "resource_bank_#{resource_bank.id}_#{role}@example.org"

        user = Decidim::User.find_or_initialize_by(email: email)
        user.update!(
          name: Faker::Name.name,
          nickname: Faker::Twitter.unique.screen_name,
          password: "decidim123456",
          password_confirmation: "decidim123456",
          organization: organization,
          confirmed_at: Time.current,
          locale: I18n.default_locale,
          tos_agreement: true
        )

        Decidim::ResourceBankUserRole.find_or_create_by!(
          user: user,
          resource_bank: resource_bank,
          role: role
        )
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
          attached_to: current_bank,
          attachment_collection: attachment_collection,
          file: File.new(File.join(seeds_root, "Exampledocument.pdf")) # Keep after attached_to
        )

        Decidim::Attachment.create!(
          title: Decidim::Faker::Localized.sentence(2),
          description: Decidim::Faker::Localized.sentence(5),
          attached_to: current_bank,
          file: File.new(File.join(seeds_root, "city.jpeg")) # Keep after attached_to
        )

        Decidim::Attachment.create!(
          title: Decidim::Faker::Localized.sentence(2),
          description: Decidim::Faker::Localized.sentence(5),
          attached_to: current_bank,
          file: File.new(File.join(seeds_root, "Exampledocument.pdf")) # Keep after attached_to
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
