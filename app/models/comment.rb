class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true
  belongs_to :resource, polymorphic: true, optional: true
  has_many :replies, foreign_key: 'parent_id', class_name: 'Comment', dependent: :destroy
  validates :content, presence: true

  validate :comment_object
  after_commit :inc_comment_count, if: -> { resource.present? && resource.respond_to?(:comments_count) }

  private
    def inc_comment_count
      resource.increment!(:comments_count)
    end

    def comment_object
      parent = Comment.find_by(id: parent_id)
      if parent.blank? && resource.blank?
        errors.add(:parent_id, "parent_id or resource should not be null")
      end
    end
end
