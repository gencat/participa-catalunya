# frozen_string_literal: true

# Override decidim permissions with DepartmentAdmin's one
Rails.application.configure do
  config.after_initialize do
    # Overrides the permissions class for the given manifest name.
    def override_permission_class_for_manifest(space, permission_class)
      manifest = Decidim.find_participatory_space_manifest(space)
      manifest.permissions_class_name = permission_class.name

      new_permission_class = Decidim.find_participatory_space_manifest(space).permissions_class_name
      Rails.logger.info("Overridden permissions class name for #{space} manifest to: #{new_permission_class}")
    end

    # Modifies the permissions registry for the given artifact with a new_permissions_class.
    # Previous permissions are cleared and set on the new_permissions_class for delegation.
    def override_registry_permissions_chain_for(artifact, permission_class)
      chain = Decidim.permissions_registry.chain_for(artifact)

      new_permission_class = Class.new(permission_class)
      new_permission_class.delegate_chain = chain.dup

      chain.clear
      chain << new_permission_class

      chain = Decidim.permissions_registry.chain_for(artifact)
      Rails.logger.info("Registered new permissions for #{artifact} to: #{chain}")
    end

    # decidim_courses
    permission_class = Decidim::Courses::ParticipatorySpacePermissions
    override_permission_class_for_manifest(:courses, permission_class)
    override_registry_permissions_chain_for(::Decidim::Courses::Admin::Concerns::CourseAdmin, permission_class)
    override_registry_permissions_chain_for(::Decidim::Courses::Admin::ApplicationController, permission_class)
  end
end
