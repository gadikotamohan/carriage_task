class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true
      t.references :authentication, type: :uuid, foreign_key: true
      t.string :token
      t.datetime :expires_at
      t.string :device_id

      t.string :client_name
      t.string :client_version
    end
  end
end
