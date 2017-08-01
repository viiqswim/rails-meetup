require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    @group = Group.new(name: "My First Meetup")
  end
  
  def add_mock_members
    @group.save
    user1 = User.create(first_name: "Joe", last_name: "User")
    user2 = User.create(first_name: "Joe", last_name: "User")
    role1 = Role.create(name: "organizer")
    role2 = Role.create(name: "participant")
    @group.add_member(user1, role1)
    @group.add_member(user2, role2)
  end
  
  test "should be valid" do
    assert @group.valid?
  end
  
  test "name should be present" do
    @group.name = "     "
      assert_not @group.valid?
  end
  
  test "#add_member adds a memer" do
    add_mock_members
    
    assert @group.users.count == 2
  end
end
