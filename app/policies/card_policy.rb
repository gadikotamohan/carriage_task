class CardPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def create?
    user.role_admin? || !user.list_users.where(list_id: record.list_id).count.zero?
  end

  def update?
    record.user_id == user.id
  end

  def destroy?
    update?
  end

  class Scope < Scope
    attr_reader :user, :scope
    def resolve
      if user.role_admin?
        scope
      else
        Card.joins(:list => :list_users).where('lists_users.user_id = :user_id or cards.user_id = :user_id', {user_id: user.id })
      end
    end
  end
end
