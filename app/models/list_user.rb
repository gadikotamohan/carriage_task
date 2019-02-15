class ListUser < ApplicationRecord
  self.table_name = 'lists_users'
  belongs_to :list
  belongs_to :user
end