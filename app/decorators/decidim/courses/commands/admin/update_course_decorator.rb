# frozen_string_literal: true

# Intercepts the `call` method and forces the Area of the user if it is a
# department_admin user.
Decidim::Courses::Admin::UpdateCourse.class_eval do
  alias_method :original_call, :call

  def call
    form.area_id = form.current_user.areas.first.id if form.current_user.department_admin?

    original_call
  end
end
