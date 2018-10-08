module AssociatedRecipesService
  def recipes_with_grouped_detail
    recipes = group_by_recipe_details
    group_by_recipe_tag_type!(recipes)
    recipes = merge_recipe_data(recipes)
    hash_ingredients_by_tag_id!(recipes)
  end

  def recipes_with_detail
    tag_selections.
      select(recipes_with_detail_select).
      left_outer_joins(recipes_with_detail_joins).
      where(taggable_type: 'Recipe')
  end

  private

    def group_by_recipe_details
      recipes_with_detail.to_a.group_by do |r|
        {
          'id' => r['recipe_id'],
          'name' => r['recipe_name'],
          'description' => r['recipe_description'],
          'instructions' => r['recipe_instructions']
        }
      end
    end

    def group_by_recipe_tag_type!(recipes)
      # mutates recipes object
      recipes.each do |k, v|
        recipes[k] = v.group_by { |g| g['tag_type'].to_s.downcase.pluralize }
      end
    end

    def hash_ingredients_by_tag_id!(recipes)
      # mutates recipes object
      recipes.each do |r|
        r['ingredients'] = r['ingredients']&.each_with_object({}) do |i, hash|
          hash[i.tag_id] = i
        end
      end
    end

    def merge_recipe_data(recipes)
      recipes.each_with_object([]) do |(k, v), new_recipes|
        new_recipes << k.merge(v)
      end
    end

    def recipes_with_detail_joins
      [
        recipe: [
          tag_selections: [
            { tag: :tag_type },
            :tag_attributes,
            :modifications
          ]
        ]
      ]
    end

    def recipes_with_detail_select
      recipes_select_recipes +
        recipes_select_tags + [
          'tag_selections_recipes.id',
          'tag_types.name AS tag_type',
          'tag_attributes.value',
          'tag_attributes.property',
          'modifications_tag_selections.name AS modification_name',
          'modifications_tag_selections.id AS modification_id'
        ]
    end

    def recipes_select_recipes
      [
        'recipes.id AS recipe_id',
        'recipes.name AS recipe_name',
        'recipes.instructions AS recipe_instructions',
        'recipes.description AS recipe_description'
      ]
    end

    def recipes_select_tags
      [
        'tags.name AS tag_name',
        'tags.description AS tag_description',
        'tags.id AS tag_id'
      ]
    end
end
