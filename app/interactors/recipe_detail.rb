class RecipeDetail
  include AssociatedRecipesService
  include Interactor

  def call
    context.result = context.recipe.tag_selections.
      select(recipes_select_tags + tag_details_select + ['tag_selections.id']).
      left_outer_joins(detail_joins).
      where("accesses.user_id =
        #{context.current_user&.id} OR accesses.status = 'PUBLIC'"
      )
  end

  private

    def detail_joins
      [
        { tag: :tag_type },
        :tag_attributes,
        :modifications,
        :access
      ]
    end
end
