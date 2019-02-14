class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.integer :role, default: 0
      t.jsonb :profile, default: '{}'
      t.timestamps
    end
  end
end
