class CreateJoinTableListsUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :lists, :users, column_options: {type: :uuid} do |t|
      t.index [:list_id, :user_id], unique: true
      t.index [:user_id, :list_id], unique: true
    end
  end
end
