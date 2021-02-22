# frozen_string_literal: true

shared_examples "manage resource admins examples" do
  let(:other_user) { create :user, organization: organization, email: "my_email@example.org" }

  let!(:resource_bank_admin) do
    create :resource_bank_admin,
           :confirmed,
           organization: organization,
           resource_bank: resource_bank
  end

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin_resource_banks.edit_resource_bank_path(resource_bank)
    click_link "Resource admins"
  end

  it "shows resource admin list" do
    within "#resource_bank_admins table" do
      expect(page).to have_content(resource_bank_admin.email)
    end
  end

  it "creates a new resource admin" do
    find(".card-title a.new").click

    within ".new_resource_bank_user_role" do
      fill_in :resource_bank_user_role_email, with: other_user.email
      fill_in :resource_bank_user_role_name, with: "John Doe"
      select "Administrator", from: :resource_bank_user_role_role

      find("*[type=submit]").click
    end

    expect(page).to have_admin_callout("successfully")

    within "#resource_bank_admins table" do
      expect(page).to have_content(other_user.email)
    end
  end

  describe "when managing different users" do
    before do
      create(:resource_bank_user_role, resource_bank: resource_bank, user: other_user)
      visit current_path
    end

    it "updates a resource admin" do
      within "#resource_bank_admins" do
        within find("#resource_bank_admins tr", text: other_user.email) do
          click_link "Edit"
        end
      end

      within ".edit_resource_bank_user_roles" do
        select "Admin", from: :resource_bank_user_role_role

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("successfully")

      within "#resource_bank_admins table" do
        expect(page).to have_content("Administrator")
      end
    end

    it "deletes a resource user_role" do
      within find("#resource_bank_admins tr", text: other_user.email) do
        accept_confirm { click_link "Delete" }
      end

      expect(page).to have_admin_callout("successfully")

      within "#resource_bank_admins table" do
        expect(page).to have_no_content(other_user.email)
      end
    end

    context "when the user has not accepted the invitation" do
      before do
        form = Decidim::ResourceBanks::Admin::ResourceBankUserRoleForm.from_params(
          name: "test",
          email: "test@example.org",
          role: "admin"
        )

        Decidim::ResourceBanks::Admin::CreateResourceBankAdmin.call(
          form,
          user,
          resource_bank
        )

        visit current_path
      end

      it "resends the invitation to the user" do
        within find("#resource_bank_admins tr", text: "test@example.org") do
          click_link "Resend invitation"
        end

        expect(page).to have_admin_callout("successfully")
      end
    end
  end
end
