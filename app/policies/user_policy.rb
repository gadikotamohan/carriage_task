class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  class Scope < Scope
    attr_reader :user, :scope
    def resolve
      if user.admin?
        scope
      else
        scope.where(id: user.id)
      end
    end
  end
end
