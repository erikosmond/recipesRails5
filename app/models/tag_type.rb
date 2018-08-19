class TagType < ApplicationRecord
  has_many :tags, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
