RSpec.shared_context 'tags', shared_context: :metadata do
  let(:type_ingredient) { create :tag_type, name: 'Ingredient' }
  let(:type_ingredient_type) { create :tag_type, name: 'IngredientType' }
  let(:type_ingredient_family) { create :tag_type, name: 'IngredientFamily' }
  let(:type_ingredient_category) { create :tag_type, name: 'IngredientCategory' }
  let!(:tag_type_modifiction_type) { create(:tag_type, name: 'IngredientModification') }
  let(:plants) { create(:tag, tag_type: type_ingredient_category, name: 'plants') }
  let(:protein) { create(:tag, tag_type: type_ingredient_family, name: 'Protein') }
  let(:nut) { create(:tag, tag_type: type_ingredient_type, name: 'Nut') }
  let(:vodka) { create(:tag, tag_type: type_ingredient, name: 'Vodka') }
  let(:almond) { create :tag, tag_type: type_ingredient, name: 'Almond' }
  let!(:tag_selection1) { create :tag_selection, tag: nut, taggable: almond }
  let!(:tag_selection2) { create :tag_selection, tag: protein, taggable: nut }
  let!(:tag_selection3) { create :tag_selection, tag: plants, taggable: protein }

  let(:vesper) { create :recipe, name: 'Vesper' }
  let(:martini) { create :recipe, name: 'Martini' }
  let(:manhattan) { create :recipe, name: 'Manhattan' }
  let!(:tag_selection4) { create :tag_selection, tag: nut, taggable: vesper }
  let!(:tag_selection4a) { create :tag_selection, tag: vodka, taggable: vesper }
  let!(:tag_selection5) { create :tag_selection, tag: almond, taggable: martini }
  let!(:tag_selection6) { create :tag_selection, tag: protein, taggable: manhattan }

  let(:modification_name1) { 'toasted' }
  let(:modification_name2) { 'crushed' }
  let(:alteration) { create(:tag_type, name: 'Alteration') }
  let(:toasted) { create(:tag, tag_type: alteration, name: modification_name1) }
  let(:crushed) { create(:tag, tag_type: alteration, name: modification_name2) }
  let!(:tag_selection_mod1) { create(:tag_selection, tag: toasted, taggable: tag_selection4) }
  let!(:tag_selection_mod2) { create(:tag_selection, tag: crushed, taggable: tag_selection4) }
  let!(:user) { create(:user) }
  let!(:non_active_user) { create(:user) }
  let!(:access1) { create(:access, user: user, accessible: vesper) }
  let!(:access2) { create(:access, user: user, accessible: martini) }
  let!(:access3) { create(:access, user: user, accessible: manhattan) }

  let!(:access4) { create(:access, user: user, accessible: tag_selection4, status: 'PRIVATE') }
  let!(:access4a) { create(:access, user: user, accessible: tag_selection4a, status: 'PUBLIC') }
  let!(:access5) { create(:access, user: user, accessible: tag_selection5, status: 'PRIVATE') }
  let!(:access6) { create(:access, user: user, accessible: tag_selection6, status: 'PRIVATE') }
  let!(:access7) { create(:access, user: user, accessible: tag_selection_mod1, status: 'PRIVATE') }
  let!(:access8) { create(:access, user: user, accessible: tag_selection_mod2, status: 'PRIVATE') }
  let!(:access9) { create(:access, user: user, accessible: tag_selection1, status: 'PRIVATE') }
  let!(:access10) { create(:access, user: user, accessible: tag_selection2, status: 'PRIVATE') }
  let!(:access11) { create(:access, user: user, accessible: tag_selection3, status: 'PRIVATE') }
end
