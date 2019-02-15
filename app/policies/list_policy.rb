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

  def update?
    user.role_admin? && user.lists.where('lists.id = ?', record.id)
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
        user.lists
      end
    end
  end
end
