class User < ApplicationRecord
    validates :first_name, presence: true, 
                 length: { maximum: 20 }
    validates :last_name, presence: true,
                 length: { maximum: 20 }
end
