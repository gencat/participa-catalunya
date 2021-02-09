# frozen_string_literal: true

#
# This decorator adds the capability to query courses
# filtering by User role `department_admin`.
#
Decidim::ResourceBanks::ResourceBanksWithUserRole.class_eval do
  private

  alias_method :resource_bank_ids_for_user_role, :resource_bank_ids

  def resource_bank_ids
    ids = resource_bank_ids_for_user_role

    if user&.department_admin?
      banks_ids_for_department = ::Decidim::ResourceBank
                                 .where(decidim_area_id: user.areas.pluck(:id))
                                 .pluck(:id)

      ids.concat(banks_ids_for_department)
    end

    ids.uniq
  end
end
