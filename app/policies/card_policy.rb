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
    true
  end

  # Member can assign or unassign on his own list
  def update?
    true
  end

  class Scope < Scope
    attr_reader :user, :scope
    def resolve
      if user.role_admin?
        scope
      else
        user.cards
      end
    end
  end
end
