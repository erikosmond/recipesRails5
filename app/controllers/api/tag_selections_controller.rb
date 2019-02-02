# frozen_string_literal: true

module Api
  class TagSelectionsController < ApplicationController
    def create
      render json: TagSelection.create!(
        tag_selection_params
      )
    end

    def update
      tag_selection = TagSelection.find(params.permit(:id)[:id])
      tag_selection.update(tag_selection_params)
      render json: tag_selection
    end

    private

      def tag_selection_params
        allowed_columns = %i[tag_id taggable_type taggable_id]
        params.require(:tag_selection).permit allowed_columns
      end
  end
end
