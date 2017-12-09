class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :body, presence: true

  def self.persisted
    where.not(id: nil)
  end
end
