# frozen_string_literal: true

shared_context "when administrating a course" do
  let(:organization) { create(:organization) }

  let!(:course) { create(:course, organization: organization) }
end
