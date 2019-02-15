class AddAppVersionToSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :app_version, :string
  end
end
