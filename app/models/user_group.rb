class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :role
    
  validates :user_id, presence: true
  validates :group_id, presence: true
  validates :role_id, presence: true
end
