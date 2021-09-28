# frozen_string_literal: true

Rails.application.config.to_prepare do
  # Main public Menu
  Decidim::MenuRegistry.find(:menu).configurations.clear
  Decidim.menu :menu do |menu|
    menu.item I18n.t("menu.home", scope: "decidim"),
              decidim.root_path,
              position: 1,
              active: :exclusive

    menu.item I18n.t("menu.assemblies", scope: "decidim"),
              decidim_assemblies.assemblies_path,
              position: 2.2,
              if: Decidim::Assemblies::OrganizationPublishedAssemblies.new(current_organization, current_user).any?,
              active: :inclusive

    menu.item I18n.t("menu.courses", scope: "decidim"),
              decidim_courses.courses_path,
              position: 2.25,
              if: Decidim::Course.where(organization: current_organization).published.any?,
              active: :inclusive

    menu.item I18n.t("menu.resource_banks", scope: "decidim"),
              decidim_resource_banks.resource_banks_path,
              position: 2.3,
              if: Decidim::ResourceBank.where(organization: current_organization).published.any?,
              active: :inclusive

    menu.item I18n.t("menu.conferences", scope: "decidim"),
              decidim_conferences.conferences_path,
              position: 2.35,
              if: Decidim::Conference.where(organization: current_organization).published.any?,
              active: :inclusive

    menu.item I18n.t("menu.decidims_finder", scope: "participacatalunya"),
              Rails.application.routes.url_helpers.decidims_finder_page_path,
              position: 6,
              active: :inclusive

    menu.item I18n.t("menu.help", scope: "decidim"),
              decidim.pages_path,
              position: 7,
              active: :inclusive
  end

  # Main public Menu
  Decidim::MenuRegistry.find(:admin_menu).configurations.clear
  Decidim.menu :admin_menu do |menu|
    menu.item I18n.t("menu.dashboard", scope: "decidim.admin"),
              decidim_admin.root_path,
              icon_name: "dashboard",
              position: 1,
              active: ["decidim/admin/dashboard" => :show]

    menu.item I18n.t("menu.assemblies", scope: "decidim.admin"),
              decidim_admin_assemblies.assemblies_path,
              icon_name: "dial",
              position: 2.2,
              active: :inclusive,
              if: allowed_to?(:enter, :space_area, space_name: :assemblies)

    menu.item I18n.t("menu.courses", scope: "decidim.admin"),
              decidim_admin_courses.courses_path,
              icon_name: "book",
              position: 2.25,
              active: :inclusive,
              if: allowed_to?(:enter, :space_area, space_name: :courses)

    menu.item I18n.t("menu.resource_banks", scope: "decidim.admin"),
              decidim_admin_resource_banks.resource_banks_path,
              icon_name: "globe",
              position: 2.3,
              active: :inclusive,
              if: allowed_to?(:enter, :space_area, space_name: :resource_banks)

    menu.item I18n.t("menu.conferences", scope: "decidim.admin"),
              decidim_admin_conferences.conferences_path,
              icon_name: "microphone",
              position: 2.8,
              active: :inclusive,
              if: allowed_to?(:enter, :space_area, space_name: :conferences)

    # menu.item I18n.t("menu.moderation", scope: "decidim.admin"),
    #           decidim_admin.moderations_path,
    #           icon_name: "flag",
    #           position: 4,
    #           active: [%w(
    #             decidim/admin/global_moderations
    #             decidim/admin/global_moderations/reports
    #           ), []],
    #           if: allowed_to?(:read, :global_moderation)

    menu.item I18n.t("menu.static_pages", scope: "decidim.admin"),
              decidim_admin.static_pages_path,
              icon_name: "book",
              position: 4.5,
              active: [%w(
                decidim/admin/static_pages
                decidim/admin/static_page_topics
              ), []],
              if: allowed_to?(:read, :static_page)

    menu.item I18n.t("menu.users", scope: "decidim.admin"),
              allowed_to?(:read, :admin_user) ? decidim_admin.users_path : decidim_admin.impersonatable_users_path,
              icon_name: "person",
              position: 5,
              active: [%w(
                decidim/admin/users
                decidim/admin/user_groups
                decidim/admin/user_groups_csv_verifications
                decidim/admin/officializations
                decidim/admin/impersonatable_users
                decidim/admin/moderated_users
                decidim/admin/managed_users/impersonation_logs
                decidim/admin/managed_users/promotions
                decidim/admin/authorization_workflows
              ), []],
              if: allowed_to?(:read, :admin_user) || allowed_to?(:read, :managed_user)

    menu.item I18n.t("menu.newsletters", scope: "decidim.admin"),
              decidim_admin.newsletters_path,
              icon_name: "envelope-closed",
              position: 6,
              active: is_active_link?(decidim_admin.newsletters_path, :inclusive) ||
                      is_active_link?(decidim_admin.newsletter_templates_path, :inclusive),
              if: allowed_to?(:index, :newsletter)

    menu.item I18n.t("menu.settings", scope: "decidim.admin"),
              decidim_admin.edit_organization_path,
              icon_name: "wrench",
              position: 7,
              active: [
                %w(
                  decidim/admin/organization
                  decidim/admin/organization_appearance
                  decidim/admin/organization_homepage
                  decidim/admin/organization_homepage_content_blocks
                  decidim/admin/scopes
                  decidim/admin/scope_types
                  decidim/admin/areas decidim/admin/area_types
                ),
                []
              ],
              if: allowed_to?(:update, :organization, organization: current_organization)

    menu.item I18n.t("menu.term_customizer", scope: "decidim.term_customizer"),
              decidim_admin_term_customizer.translation_sets_path,
              icon_name: "text",
              position: 7.1,
              active: :inclusive,
              if: allowed_to?(:update, :organization, organization: current_organization)

    menu.item I18n.t("menu.admin_log", scope: "decidim.admin"),
              decidim_admin.logs_path,
              icon_name: "dashboard",
              position: 10,
              active: [%w(decidim/admin/logs), []],
              if: allowed_to?(:read, :admin_log)
  end
end
