class Api::RecipesController < ApplicationController
  def index
    recipe_params = params.permit(:tag_id)
    tag = Tag.find_by_id(recipe_params[:tag_id])
    @recipes =
      if tag
        tag.recipes_with_grouped_detail
      else
        Recipe.all.as_json(recipes_response_json)
      end
    # group_recipe_properties
    render json: @recipes
  end

  private

    def index_response_json
      {
        only: %i[name id],
        include: {
          recipes: recipes_as_json
        }
      }
    end

    def recipes_as_json
      {
        only: %i[name instructions description],
        include: {
          tag_selections: tag_selections_as_json
        }
      }
    end

    def tag_selections_as_json
      {
        only: %i[id],
        include: {
          tag_attributes: {
            only: %i[property value]
          },
          tag: tag_as_json
        }
      }
    end

    def tag_as_json
      {
        only: %i[name id],
        include: {
          tag_type: {
            only: %i[name id]
          }
        }
      }
    end

    def group_recipe_properties
      @recipes.map do |r|
        tag_selections = r['tag_selections'].
                         group_by { |ts| ts['tag']['tag_type']['name'] }
        r['tag_selections'] = tag_selections
      end
    end
end
