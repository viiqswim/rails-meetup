require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  def setup 
    @role = Role.new(name: "Organizer")
  end
  
  test "should be valid" do
    assert @role.valid?
  end
  
  test "name should be present" do
    @role.name = "     "
    assert_not @role.valid?
  end
end
