require 'spec_helper'

describe Tool do

  let(:tool) { FactoryGirl.create(:tool, name: 'Shopbot') }

  # describe :unauthenticated do
  #   it "has no index" do
  #     visit tools_path
  #     expect(page.status_code).to eq(403)
  #   end

  # end

  describe :user do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @user.verify!
      sign_in @user
    end

    it "has no index" do
      visit tools_path
      expect(page.status_code).to eq(403)
    end

    it "cannot create tool" do
      visit tools_path
      expect(page).to_not have_link("Add lab")
      visit new_tool_path
      expect(page.status_code).to eq(403)
    end

    it "cannot edit tool" do
      visit tool_path(tool)
      expect(page).to_not have_link("Edit Tool")
      visit edit_tool_path(tool)
      expect(page.status_code).to eq(403)
    end

  end

  describe :admin do
    before(:each) do
      @admin = FactoryGirl.create(:user)
      @admin.add_role :admin
      sign_in @admin
    end

    # it "has index" do
    #   tool.reload
    #   visit tools_path
    #   expect(page).to have_title('Tools')
    #   expect(page).to have_link('Shopbot')
    # end

    # it "has show page" do
    #   visit tool_path(tool)
    #   expect(page).to have_title(tool.name)
    #   expect(page).to have_css('h1', text: tool.name)
    # end

    # it "can create tool" do
    #   visit tools_path
    #   click_link "New Tool"
    #   fill_in "Name", with: "Replicator 2"
    #   fill_in "Description", with: "3D Printer"
    #   click_button "Create Tool"
    #   expect(page).to have_css("h1", text: "Replicator 2")
    # end

    # it "can edit tool" do
    #   visit tool_path(tool)
    #   click_link "Edit"
    #   fill_in "Name", with: "SHOP BOT"
    #   click_button "Update Tool"
    #   expect(page).to have_css("h1", text: "SHOP BOT")
    # end

  end

end