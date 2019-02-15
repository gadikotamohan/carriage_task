class CommentPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def create?
    flag = false
    return true if user.role_admin?
    parent = record.parent || record

    if parent.resource.class == Card
      flag = !user.lists_users.where(list_id: parent.resource_id).count.zero?
    end
    flag
  end

  def update?
    true
  end

  class Scope < Scope
    attr_reader :user, :scope
    def resolve
      if user.role_admin?
        scope
      else
        Comment.left_join(:replies).where(user_id: user.id)
      end
    end
  end
end
