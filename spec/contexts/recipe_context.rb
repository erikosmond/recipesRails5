RSpec.shared_context 'recipes', shared_context: :metadata do
  let(:modification_name) { 'chili infused' }
  let(:recipe1_name) { 'Pizza' }
  let(:recipe1_description) { 'New York Style' }
  let(:recipe2_name) { 'Chesnut Soup' }
  let(:recipe2_description) { 'Winter Warmer' }
  let(:recipe2_instructions) { 'Stir the soup' }
  let(:ingredient1_name) { 'salt' }
  let(:ingredient1_verbena) { 'Lemon Verbena' }
  let(:ingredient2_name) { 'pepper' }
  let(:ingredient1_type_name) { 'spices' }
  let(:ingredient1_family_name) { 'seasoning' }
  let(:property) { 'Amount' }
  let(:value) { '1 ounce' }
  let(:recipe1) { create(:recipe, name: recipe1_name, description: recipe1_description) }
  let(:recipe2) { create(:recipe, name: recipe2_name, description: recipe2_description, instructions: recipe2_instructions) }
  let(:tag_type_rating) { create(:tag_type, name: 'Rating') }
  let(:tag_type_ingredient) { create(:tag_type, name: 'Ingredient') }
  let(:tag_type_ingredient_type) { create(:tag_type, name: 'IngredientType') }
  let(:tag_type_ingredient_family) { create(:tag_type, name: 'IngredientFamily') }
  let(:tag_type_not_ingredient) { create(:tag_type, name: 'NotIngredient') }
  let(:alteration) { create(:tag_type, name: 'Alteration') }
  let(:lemon_verbena) { create(:tag, tag_type: tag_type_ingredient, name: ingredient1_verbena) }
  let(:rating) { create(:tag, tag_type: tag_type_rating, name: 'Rating: 9') }
  let(:ingredient1) { create(:tag, tag_type: tag_type_ingredient, name: ingredient1_name) }
  let(:ingredient1_type) { create(:tag, tag_type: tag_type_ingredient_type, name: ingredient1_type_name) }
  let(:ingredient1_family) { create(:tag, tag_type: tag_type_ingredient_family, name: ingredient1_family_name) }
  let(:ingredient1_unrelated) { create(:tag, tag_type: tag_type_not_ingredient, name: 'not related') }
  let(:ingredient2) { create(:tag, tag_type: tag_type_ingredient, name: ingredient2_name) }
  let(:modification) { create(:tag, tag_type: alteration, name: modification_name) }
  let!(:tag_selection1) { create(:tag_selection, tag: tag_subject, taggable: recipe1) }
  let!(:tag_selection1a) { create(:tag_selection, tag: lemon_verbena, taggable: recipe1) }
  let!(:tag_selection2a) { create(:tag_selection, tag: tag_subject, taggable: recipe2) }
  let!(:tag_selection2b) { create(:tag_selection, tag: ingredient1, taggable: recipe2) }
  let!(:tag_selection2c) { create(:tag_selection, tag: ingredient2, taggable: recipe2) }
  let!(:tag_selection2ba) { create(:tag_selection, tag: ingredient1_type, taggable: ingredient1) }
  let!(:tag_selection2bb) { create(:tag_selection, tag: ingredient1_family, taggable: ingredient1_type) }
  let!(:tag_attribute) { create(:tag_attribute, property: property, value: value, tag_attributable: tag_selection2b) }
  let!(:tag_selection_mod) { create(:tag_selection, tag: modification, taggable: tag_selection2b) }
  let!(:user) { create(:user) }
  let!(:non_active_user) { create(:user) }
  let!(:access1a) { create(:access, user: user, accessible: recipe1, status: 'PUBLIC') }
  let!(:access1b) { create(:access, user: user, accessible: tag_selection1, status: 'PRIVATE') }
  let!(:access1c) { create(:access, user: user, accessible: tag_selection2a, status: 'PUBLIC') }
  let!(:access2) { create(:access, user: user, accessible: recipe2, status: 'PUBLIC') }
  let!(:recipes) { RecipeByTag.call(tag: tag_subject, current_user: user).result }
end
