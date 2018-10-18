class Api::RecipesController < ApplicationController
  def index
    recipe_params = params.permit(:tag_id)
    tag = Tag.find_by_id(recipe_params[:tag_id])
    @recipes = if tag
                 tagged_recipes(tag)
               else
                 { tag: { name: 'All Recipes' }, recipes: all_recipe_json }
               end
    render json: @recipes
  end

  private

    def tagged_recipes(tag)
      recipes = tag.recipes_with_detail
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
