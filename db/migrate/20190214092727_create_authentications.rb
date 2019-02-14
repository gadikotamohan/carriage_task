class CreateAuthentications < ActiveRecord::Migration[5.2]
  def change
    create_table :authentications, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.string :provider
      t.string :uid
      t.hstore :credentials
      t.datetime :expires_at
    end
  end
end
