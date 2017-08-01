class User < ApplicationRecord
  has_many :user_groups
  has_many :groups, through: :user_groups
  
  validates :first_name, presence: true, 
                 length: { maximum: 20 }
  validates :last_name, presence: true,
                 length: { maximum: 20 }
end
