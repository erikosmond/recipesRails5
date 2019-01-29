# frozen_string_literal: true

module Api
  class TagsController < ApplicationController
    def index
      tag_type = params.permit(:type)[:type]
      tags = if tag_type
               tags_by_type(tag_type)
             else
               tag_json = Tag.all.as_json(only: %i[id name])
               tag_json.map { |r| { 'Label' => r['name'], 'Value' => r['id'] } }
             end
      if tags
        if tag_type
          render json: { tags: tags }
        else
          render json: { tags: tags, tag_groups: Tag.ingredient_group_heirarchy_filters(current_user) }
        end
      else
        render json: { tag_type: tag_type.to_s }, status: :not_found
      end
    end

    def show
      tag = Tag.find_by_id(params.permit(:id)[:id])
      if tag
        render json: tag.tag_with_heirarchy_grouped(current_user)
      else
        render json: { tag: tag.to_s }, status: :not_found
      end
    end

    private

      def tags_by_type(tag_type)
        type_ids = tag_types(tag_type).pluck(:id)
        tag_json = Tag.where(tag_type_id: type_ids).as_json(only: %i[id name])
        tag_json.map { |r| { 'Label' => r['name'], 'Value' => r['id'] } }
      end

      def tag_types(tag_type)
        ingredient_types = TagType::INGREDIENT_TYPES
        if tag_type.to_s.casecmp('ingredients').zero?
          TagType.where(name: ingredient_types)
        elsif tag_type
          TagType.where.not(name: ingredient_types)
        else
          TagType.all
        end
      end
  end
end
