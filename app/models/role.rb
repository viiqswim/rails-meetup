class Role < ApplicationRecord
    has_many :user_groups
    
    validates :name, presence: true
end
