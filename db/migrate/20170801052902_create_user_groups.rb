class CreateUserGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :user_groups do |t|
      t.references :user, foreign_key: true
      t.string :user
      t.references :group, foreign_key: true
      t.string :group
      t.references :role, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
