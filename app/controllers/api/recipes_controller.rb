# frozen_string_literal: true

module Api
  class RecipesController < ApplicationController
    def index
      tag_id = params.permit(:tag_id)[:tag_id]
      recipes = recipes_by_tag(tag_id)
      if recipes
        render json: recipes
      else
        render json: { tag_id: tag_id.to_s }, status: :not_found
      end
    end

    def show
      recipe = Recipe.find_by_id(params.permit(:id)[:id])
      if recipe
        render json: recipe
      else
        render json: {}, status: :not_found
      end
    end

    private

      def recipes_by_tag(tag_id)
        tag = Tag.find_by_id(tag_id)
        if tag
          tagged_recipes(tag)
        elsif tag_id.nil?
          { tag: { name: 'All Recipes' }, recipes: all_recipe_json }
        end
      end

      def tagged_recipes(tag)
        recipes = tag.recipes_with_detail.to_a
        {
          tag: tag,
          recipes: tag.recipes_with_grouped_detail(recipes),
          filter_tags: tag.filter_tags(recipes)
        }
      end

      def all_recipe_json
        Recipe.all.as_json(only: %i[id name])
      end
  end
end
