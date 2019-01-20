class ChildTag < Tag
  self.table_name = 'child_tags'

  belongs_to :tag_type
  has_many :child_tags,
           through: :tag_selections,
           source: :taggable,
           class_name: 'ChildTag',
           source_type: 'Tag'
end
