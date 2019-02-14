class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :cards, id: :uuid do |t|
      t.text :title
      t.text :description
      t.integer :comments_count, default: 0
      t.references :list, type: :uuid, foreign_key: true
      t.references :user, type: :uuid, foreign_key: true

      t.timestamps
    end

    create_table :comments, id: :uuid do |t|
      t.text :content
      t.references :user, type: :uuid, foreign_key: true
      t.uuid :parent_id
      t.uuid :resource_id
      t.string :resource_type
      t.integer :replies_count, default: 0

      t.timestamps
    end

    add_column :lists, :comments_count, :integer, default: 0
    add_index :comments, :parent_id
    add_foreign_key :comments, :comments, column: :parent_id, name: "parent_id_comment_id"
  end
end
