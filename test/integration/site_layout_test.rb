require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  setup do
     @group = Group.create(name: "test-group") 
  end
  
  def add_mock_members
    user1 = User.create(first_name: "Joe", last_name: "User")
    user2 = User.create(first_name: "Joe", last_name: "User")
    role1 = Role.find_by name: "organizer"
    role2 = Role.find_by name: "participant"
    @group.add_member(user1, role1)
    @group.add_member(user2, role2)
  end
    
  test "Root page layout" do
    get root_path
    
    assert_template 'groups/all_groups'
    assert_select "h2", "Groups"
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", meetup_file_import_path, count: 2
  end
  
  test "File upload page layout" do
    get meetup_file_import_path
    
    assert_template 'groups/file_upload'
    assert_select "h2", "Import a CSV file"
    assert_select "input[type=submit]"
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", meetup_file_import_path, count: 2
  end
  
  test "Group members (show) page without members in the group" do
    get group_members_path(@group)

    assert_template 'groups/show'
    assert_select "h2", "Group Members"
    assert_select "p", "There are no members yet."
    assert_select "a[href=?]", group_organizers_path(@group)
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", meetup_file_import_path, count: 3
  end
  
  test "Group members (show) page with members in the group" do
    add_mock_members
    get group_members_path(@group)

    assert_template 'groups/show'
    assert_select "h2", "Group Members"
    assert_select "table"
    assert_select "tr", count: 3
    assert_select "a[href=?]", group_organizers_path(@group)
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", meetup_file_import_path, count: 2
  end
  
  test "Group organizers (index) page without organizers in the group" do
    get group_organizers_path(@group)

    assert_template 'groups/index'
    assert_select "h2", "Group Organizers"
    assert_select "p", "There are no organizers yet."
    assert_select "a[href=?]", group_members_path(@group)
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", meetup_file_import_path, count: 3
  end
  
  test "Group organizers (index) page with organizers in the group" do
    add_mock_members
    get group_organizers_path(@group)

    assert_template 'groups/index'
    assert_select "h2", "Group Organizers"
    assert_select "table"
    assert_select "tr", count: 2
    assert_select "a[href=?]", group_members_path(@group)
    assert_select "a[href=?]", root_path, count: 3
    assert_select "a[href=?]", meetup_file_import_path, count: 2
  end
  
end