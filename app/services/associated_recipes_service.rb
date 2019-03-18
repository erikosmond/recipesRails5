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
      tags[r.tag_id] = r.tag_name
      tags[r.parent_tag_id] = r.parent_tag
      tags[r.grandparent_tag_id] = r.grandparent_tag
      tags[r.modification_id] = r.modification_name
    end
    result.reject { |k, v| k.blank? || v.blank? }.to_a
  end

  def recipe_detail_level(current_user)
    recipes = case tag_type_name
              when 'IngredientType'
                child_recipes_with_detail(current_user).to_a
              when 'IngredientFamily'
                grandchild_recipes_with_detail(current_user).to_a +
                child_recipes_with_detail(current_user).to_a
              when 'IngredientModification'
                modification_recipes_detail(current_user).to_a
              end || []
    recipes + recipes_with_detail(current_user).to_a
  end

  def recipe_detail(current_user)
    detail_joins = [
      { tag: :tag_type },
      :tag_attributes,
      :modifications,
      :access
    ]
    tag_selections.
      select(recipes_select_tags + tag_details_select + ['tag_selections.id']).
      left_outer_joins(detail_joins).
      where("accesses.user_id = #{current_user&.id} OR accesses.status = 'PUBLIC'")
  end

  # should be private method, but is being used explicitly in testing for now
  def recipes_with_detail(current_user)
    ts = TagSelection.
         select(recipes_with_detail_select + ['tag_selections_recipes.id']).
         left_outer_joins(
           [:access, recipe: { tag_selections: recipes_with_parent_detail_joins }]
         )
    add_predicates(ts, current_user)
  end

  private

    def modification_recipes_detail(current_user)
      join_alias = 'tag_selections_modified_recipe_tag_selections_2'
      detail_sql(modified_recipe_tag_selections, join_alias, current_user)
    end

    def child_recipes_with_detail(current_user)
      join_alias = 'child_tag_selections_child_recipe_tag_selections'
      detail_sql(child_recipe_tag_selections, join_alias, current_user)
    end

    def grandchild_recipes_with_detail(current_user)
      join_alias = 'grandchild_tag_selections_grandchild_recipe_tag_selections'
      detail_sql(grandchild_recipe_tag_selections, join_alias, current_user)
    end

    def add_predicates(tag_selections, current_user)
      tag_selections.
        where("tag_selections.tag_id = #{id}").
        where('tag_selections.id IS NOT NULL').
        where('recipes.id IS NOT NULL').
        where('tag_selections_recipes.id IS NOT NULL').
        where('accesses_selected_recipes.id IS NOT NULL').
        where('accesses.id IS NOT NULL').
        where("accesses_selected_recipes.user_id = #{current_user&.id} OR
               accesses_selected_recipes.status = 'PUBLIC'").
        where("accesses.user_id = #{current_user&.id} OR accesses.status = 'PUBLIC'")
    end

    def detail_sql(selected_tags, tag_selection_table_name, current_user)
      selected_tags.
        select(recipes_with_detail_select + ["#{tag_selection_table_name}.id"]).
        left_outer_joins(recipes_with_parent_detail_joins).
        where("accesses.user_id = #{current_user&.id} OR accesses.status = 'PUBLIC'")
    end

    def recipes_with_parent_detail_joins
      [
        { tag: [:tag_type, parent_tags: [:tag_type, parent_tags: :tag_type]] },
        :tag_attributes,
        :modifications,
        selected_recipe: :access
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
          tag_ids[r.try(:parent_tag_id)] = true
          tag_ids[r.try(:grandparent_tag_id)] = true
          tag_ids[r.try(:modification_id)] = true
        end
        k['tag_ids'] = ids.select { |key, _v| key.present? }
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
      recipes.map { |k, v| k.merge(v) }
    end

    def recipes_with_detail_select
      recipes_select_tags +
        recipes_select_parent_tags +
        tag_details_select +
        recipes_select_recipes
    end

    def tag_details_select
      [
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
        'tags.tag_type_id AS tag_type_id'
      ]
    end

    def recipes_select_parent_tags
      [
        'parent_tags_tags.name AS parent_tag',
        'parent_tags_tags.id AS parent_tag_id',
        'parent_tags_tags_2.name AS grandparent_tag',
        'parent_tags_tags_2.id AS grandparent_tag_id'
      ]
    end
end
