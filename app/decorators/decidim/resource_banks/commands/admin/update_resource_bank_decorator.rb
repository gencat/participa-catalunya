# frozen_string_literal: true

# Intercepts the `call` method and forces the Area of the user if it is a
# department_admin user.
Decidim::ResourceBanks::Admin::UpdateResourceBank.class_eval do
  alias_method :original_call, :call

  def call
    if form.current_user.department_admin?
      form.area_id = form.current_user.areas.first.id
    end

    original_call
  end
end
