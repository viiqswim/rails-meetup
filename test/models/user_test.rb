require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(first_name: "Joe", 
                     last_name: "User")
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
end
