# frozen_string_literal: true

# Fetch all tags related to a given recipe. This includes ingredients, vessels,
# sources, etc.
class TagSelectionFactory
  include Interactor

  RATED_TAG = 'Been Made'

  def call
    context.result = case context.action
                     when :create
                       create(context.params)
                     when :update
                       update(context.params)
                     end
    invoke_side_effects
  end

  private

    def create(params)
      TagSelection.create!(params)
    end

    def update(params)
      context.tag_selection.tap { |ts| ts.update(params) }
    end

    def invoke_side_effects
      handle_rating
    end

    def handle_rating
      tag = context.tag_selection.tag
      return if tag.tag_type_id != TagType.rating_id

      rated_tag = Tag.find_by_name(RATED_TAG)
      create(taggable: context.tag_selection.taggable, tag: rated_tag)
    end
end
