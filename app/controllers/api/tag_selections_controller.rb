# frozen_string_literal: true

module Api
  # Used to assign tags like rating and priority to a given recipe.
  class TagSelectionsController < ApplicationController
    def create
      result = TagSelectionFactory.call(
        action: :create,
        params: tag_selection_params
      )
      render json: result.tag_selection
    end

    def update
      tag_selection = TagSelection.find(params.permit(:id)[:id])
      result = TagSelectionFactory.call(
        action: :update,
        tag_selection: tag_selection,
        params: tag_selection_params
      )
      render json: result.tag_selection
    end

    private

      def tag_selection_params
        allowed_columns = %i[tag_id taggable_type taggable_id]
        params.require(:tag_selection).permit allowed_columns
      end
  end
end
