class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :firstName
      t.string :lastName
      t.string :auth_token

      t.timestamps null: false
    end
  end
end
