# frozen_string_literal: true

#
# This decorator adds the capability to the controller to query resource
# banks filtering by User role `department_admin`.
#
Decidim::ResourceBanks::Admin::ResourceBanksController.class_eval do
  private

  alias_method :original_collection, :collection

  def collection
    if current_user.admin?
      original_collection
    else
      ::Decidim::ResourceBanks::ResourceBanksWithUserRole.for(current_user)
    end
  end
end
