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
        render json: tags
      else
        render json: { tag_type: tag_type.to_s }, status: :not_found
      end
    end

    def show
      tag = Tag.find_by_id(params.permit(:id)[:id])
      if tag
        render json: tag.tag_with_heirarchy_grouped
      else
        render json: { tag: tag.to_s }, status: :not_found
      end
    end

    private

      def tags_by_type(tag_type)
        tag_types = tag_types(tag_type)
          tag_json = tag_types.flat_map(&:tags).as_json(only: %i[id name])
          tag_json.map { |r| { 'Label' => r['name'], 'Value' => r['id'] } }
      end

      def tag_types(tag_type)
        ingredients = %w[Ingredient IngredientType IngredientFamily]
        if tag_type.to_s.casecmp('ingredients').zero?
          TagType.where(name: ingredients)
        elsif tag_type
          TagType.where.not(name: ingredients)
        else
          TagType.all
        end
      end
  end
end
