class Group < ApplicationRecord
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
    
  validates :name, presence: true
  
  def add_member(user, role)
    return UserGroup.create(group_id: id, user_id: user.id, role_id: role.id)
  end
end
