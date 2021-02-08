# frozen_string_literal: true

#
# This decorator adds the capability to query courses
# filtering by User role `department_admin`.
#
Decidim::Courses::CoursesWithUserRole.class_eval do
  private

  alias_method :course_ids_for_user_role, :course_ids

  def course_ids
    ids = course_ids_for_user_role

    if user&.department_admin?
      course_ids_for_department = ::Decidim::Course
                                  .where(decidim_area_id: user.areas.pluck(:id))
                                  .pluck(:id)

      ids.concat(course_ids_for_department)
    end

    ids.uniq
  end
end
