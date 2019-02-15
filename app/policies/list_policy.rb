class ListPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def create?
    user.role_admin?
  end

  # Member can assign or unassign on his own list
  def update?
    user.role_admin? && user.list_ids.include?(record.id)
  end

  def destroy?
    user.role_admin? && user.list_ids.include?(record.id)
  end

  class Scope < Scope
    attr_reader :user, :scope
    def resolve
      if user.role_admin?
        scope
      else
        user.lists
      end
    end
  end
end
