# frozen_string_literal: true

Decidim.register_participatory_space(:ResourceBank) do |participatory_space|
  participatory_space.icon = "decidim/ResourceBank/icon.svg"
  participatory_space.model_class_name = "Decidim::ResourceBank"

  participatory_space.participatory_spaces do |organization|
    Decidim::ResourceBank.where(organization: organization)
  end

  participatory_space.permissions_class_name = "Decidim::ResourceBank::Permissions"

  # participatory_space.query_type = "Decidim::ResourceBank::ResourceBankType"

  participatory_space.register_resource(:resource_bank) do |resource|
    resource.model_class_name = "Decidim::ResourceBank"
    # resource.card = "decidim/resource_bank/resource_bank"
    # resource.searchable = true
  end

  participatory_space.context(:public) do |context|
    context.engine = Decidim::ResourceBank::Engine
    # context.layout = "layouts/decidim/resource_bank"
  end

  participatory_space.context(:admin) do |context|
    context.engine = Decidim::ResourceBank::AdminEngine
    # context.layout = "layouts/decidim/admin/resource_bank"
  end

  participatory_space.register_on_destroy_account do |user|
    # TODO
  end

  participatory_space.seeds do
  end
end
