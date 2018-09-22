class Api::RecipesController < ApplicationController
  def index
    recipe_params = params.permit(:tag_id)
    tag = Tag.find_by_id(recipe_params[:tag_id])
    if tag
      @recipes = tag.recipes
    else
      @recipes = Recipe.all
    end
    render json: @recipes
  end
end
