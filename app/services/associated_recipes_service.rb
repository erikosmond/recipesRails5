module AssociatedRecipesService
  def recipes_with_grouped_detail(recipe_details)
    recipes = group_by_recipe_details(recipe_details.dup)
    collect_tags_by_recipe!(recipes)
    recipes = group_by_recipe_tag_type(recipes) # Ingredients, vs Menus, etc.
    recipes = merge_recipe_data(recipes)
    hash_ingredients_by_tag_id!(recipes)
  end

  def filter_tags(recipe_details)
    result = recipe_details.each_with_object({}) do |r, tags|
      tags[r.tag_id] = true
      tags[r.ingredient_type_id] = true
      tags[r.ingredient_family_id] = true
    end
    result.reject { |k, _v| k.nil? }
  end

  def recipe_detail_level
    recipes =
      case tag_type.name
      when 'IngredientType'
        child_recipes_with_detail.to_a
      when 'IngredientFamily'
        grandchild_recipes_with_detail.to_a +
        child_recipes_with_detail.to_a
      end || []
    recipes + recipes_with_detail.to_a
  end

  def recipes_with_detail
    join_alias = 'tag_selections_recipe_tag_selections'
    parent_type, grandparent_type = parent_type_names_by_type('self')
    detail_sql(recipe_tag_selections, join_alias, parent_type, grandparent_type)
  end

  def child_recipes_with_detail
    join_alias = 'child_tag_selections_child_recipe_tag_selections'
    parent_type, grandparent_type = parent_type_names_by_type('child')
    detail_sql(child_recipe_tag_selections, join_alias, parent_type, grandparent_type)
  end

  def grandchild_recipes_with_detail
    join_alias = 'grandchild_tag_selections_grandchild_recipe_tag_selections'
    parent_type, grandparent_type = parent_type_names_by_type('grandchild')
    detail_sql(grandchild_recipe_tag_selections, join_alias, parent_type, grandparent_type)
  end

  private

    def detail_sql(selected_tags, tag_selection_table_name, parent, grandparent)
      selected_tags.
        select(recipes_with_detail_select(tag_selection_table_name)).
        left_outer_joins(recipes_with_parent_detail_joins).
        where(parent).
        where(grandparent)
    end

    def recipes_with_parent_detail_joins
      [
        { tag: [:tag_type, tags: [:tag_type, tags: :tag_type]] },
        :tag_attributes,
        :modifications
      ]
    end

    def group_by_recipe_details(recipe_details)
      recipe_details.to_a.group_by do |r|
        {
          'id' => r['recipe_id'],
          'name' => r['recipe_name'],
          'description' => r['recipe_description'],
          'instructions' => r['recipe_instructions']
        }
      end
    end

    def group_by_recipe_tag_type(ungrouped_recipes)
      ungrouped_recipes.each_with_object({}) do |(k, v), recipes|
        recipes[k] = v.group_by { |g| g['tag_type'].to_s.downcase.pluralize }
      end
    end

    def collect_tags_by_recipe!(recipes)
      # mutates recipes object
      recipes.each do |k, v|
        ids = v.each_with_object({}) do |r, tag_ids|
          tag_ids[r.tag_id] = true
          tag_ids[r.ingredient_type_id] = true
          tag_ids[r.ingredient_family_id] = true
        end
        k['tag_ids'] = ids
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

    def recipes_with_detail_select(tag_selection_table_name)
      recipes_select_recipes +
        recipes_select_tags + [
          "#{tag_selection_table_name}.id",
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
        'tags.id AS tag_id',
        'tags_tags.name AS ingredient_type',
        'tags_tags.id AS ingredient_type_id',
        'tags_tags_2.name AS ingredient_family',
        'tags_tags_2.id AS ingredient_family_id'
      ]
    end

    def parent_type_names_by_type(recipe_level)
      case tag_type.name
      when 'Ingredient'
        ingredient_parent_types
      when 'IngredientType'
        ingredient_type_parent_types(recipe_level)
      when 'IngredientFamily'
        ingredient_family_parent_types(recipe_level)
      end
    end

    def ingredient_parent_types
      [
        "tag_types_tags.name = 'IngredientType'",
        "tag_types_tags_2.name = 'IngredientFamily'"
      ]
    end

    def ingredient_type_parent_types(recipe_level)
      case recipe_level
      when 'self'
        ingredient_type_parent_type
      when 'child'
        ingredient_parent_types
      end
    end

    def ingredient_family_parent_types(recipe_level)
      case recipe_level
      when 'self'
        ingredient_family_parent_type
      when 'child'
        ingredient_type_parent_type
      when 'grandchild'
        ingredient_parent_types
      end
    end

    def ingredient_type_parent_type
      [
        "tag_types_tags.name = 'IngredientFamily'",
        'tag_types_tags_2.name IS NULL'
      ]
    end

    def ingredient_family_parent_type
      [
        'tag_types_tags.name IS NULL',
        'tag_types_tags_2.name IS NULL'
      ]
    end
end
