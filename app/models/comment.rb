class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true
  belongs_to :resource, polymorphic: true

  validates :content, presence: true

  after_commit :inc_comment_count, if: -> { resource.present? && resource.respond_to?(:comments_count) }

  private
    def inc_comment_count
      resource.increment!(:comments_count)
    end

end
