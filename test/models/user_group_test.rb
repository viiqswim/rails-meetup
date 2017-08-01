require 'test_helper'

class UserGroupTest < ActiveSupport::TestCase
  def setup
    group = Group.create(name: "test-group")
    user = User.create(first_name: "Joe", last_name: "User")
    role = Role.first
    @user_group = UserGroup.new(user_id: user.id, group_id: group.id, role_id: role.id)
  end
  
  test "should be valid" do
    assert @user_group.valid?
  end
  
  test "should not be valid" do
    @user_group.user_id = nil
    @user_group.group_id = nil
    @user_group.role_id = nil
    assert_not @user_group.valid?
  end
end
