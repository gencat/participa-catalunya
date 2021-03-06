# frozen_string_literal: true

shared_context "when administrating a resource" do
  let(:organization) { create(:organization) }

  let!(:resource_bank) { create(:resource_bank, organization: organization) }
end
