# frozen_string_literal: true

shared_context "when course admin administrating a course" do
  let!(:user) do
    create(
      :course_admin,
      :confirmed,
      organization: organization,
      course: course
    )
  end

  include_context "when administrating a course"
end
