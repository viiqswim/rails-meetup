class User < ApplicationRecord
  has_many :user_groups
  has_many :groups, through: :user_groups
  
  attr_accessor :role
  
  validates :first_name, presence: true, 
                 length: { maximum: 20 }
  validates :last_name, presence: true,
                 length: { maximum: 20 }
                 
 def role(group_id)
    user_group = user_groups.find_by(group_id: group_id)
    
    return user_group.role
  end
end
