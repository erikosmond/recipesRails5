# frozen_string_literal: true

module Api
  class TagsController < ApplicationController
    def index
      tag_type = params.permit(:type)[:type]
      tags = tags_by_type(tag_type)
      if tags
        render json: tags
      else
        render json: { tag_type: tag_type.to_s }, status: :not_found
      end
    end

    private

      def tags_by_type(tag_type)
        selected_tags = tag_types(tag_type)
        tag_types = TagType.where(name: selected_tags)
        tag_json = tag_types.flat_map(&:tags).as_json(only: %i[id name])
        tag_json.map { |r| { 'Label' => r['name'], 'Value' => r['id'] } }
      end

      def tag_types(tag_type)
        {
          'ingredients' => %w[Ingredient IngredientType IngredientFamily]
        }[tag_type]
      end
  end
end
