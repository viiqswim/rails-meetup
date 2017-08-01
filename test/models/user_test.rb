require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Joe", 
                     last_name: "User")
  end
  
  def add_mock_data(role_name)
    @user.save
    @role = Role.find_by(name: role_name)
    @group = Group.create(name: "test-group")
    @group.add_member(@user, @role)
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.first_name = "     "
    @user.last_name = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.first_name = "a" * 50
    @user.last_name = "b" * 50
    assert_not @user.valid?
  end
  
  test "#role returns the correct role" do
    add_mock_data("organizer")
    role = @user.role(@group.id)
    
    assert role == @role
  end
  
  test "#is_organizer? returns true if user is organizer" do
    add_mock_data("organizer")
    
    assert @user.is_organizer?(@group.id)
  end
  
  test "#is_organizer? returns false if user is not organizer" do
    add_mock_data("presenter")
    
    assert_not @user.is_organizer?(@group.id)
  end
  
  test "#full_name returns the user's full name" do
    full_name = @user.first_name + " " + @user.last_name
    assert @user.full_name == full_name
  end
end
