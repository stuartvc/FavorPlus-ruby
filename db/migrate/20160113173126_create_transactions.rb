class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :value
      t.string :description

      t.timestamps null: false
    end
  end
end
