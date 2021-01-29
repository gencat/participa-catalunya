# frozen_string_literal: true

shared_context "when resource_bank admin administrating a resource_bank" do
  let!(:user) do
    create(
      :resource_bank_admin,
      :confirmed,
      organization: organization,
      resource_bank: resource_bank
    )
  end

  include_context "when administrating a resource_bank"
end
