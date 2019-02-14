class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists, id: :uuid do |t|
      t.string :title
      t.references :user, type: :uuid, foreign_key: true

      t.timestamps
    end

    add_column :users, :lists_count, :integer, default: 0
  end
end
