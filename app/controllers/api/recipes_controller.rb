class Api::RecipesController < ApplicationController
  def index
    recipe_params = params.permit(:tag_id)
    tag = Tag.find_by_id(recipe_params[:tag_id])
    if tag
      @recipes = tag.recipes.as_json(
        only: %i(name instructions description),
        include: {
          tags: {
            only: %i(name),
            include: {
              tag_type: {
                only: %i(name)
              }
            }
          }
        }
      )
    else
      @recipes = Recipe.all.as_json(
        only: %i(name instructions description),
        include: {
          tags: {
            only: %i(name)
          }
        }
      )
    end
    render json: @recipes
  end
end
