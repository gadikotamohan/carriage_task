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
    create?
  end

  class Scope < Scope
    attr_reader :user, :scope
    def resolve
      if user.role_admin?
        scope
      else
        user.send(scope.to_s.underscore.pluralize)
      end
    end
  end
end
