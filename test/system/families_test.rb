# frozen_string_literal: true

require 'application_system_test_case'

class FamiliesTest < ApplicationSystemTestCase
  setup do
    @family = families(:one)
  end

  test 'visiting the index' do
    visit families_url
    assert_selector 'h1', text: 'Families'
  end

  test 'creating a Family' do
    visit families_url
    click_on 'New Family'

    check 'Always vertical' if @family.always_vertical
    fill_in 'Fitting type', with: @family.fitting_type
    fill_in 'Name', with: @family.name
    check 'Room calculation point' if @family.room_calculation_point
    fill_in 'Round dimension', with: @family.round_dimension
    check 'Shared' if @family.shared
    fill_in 'Unique', with: @family.unique_id
    check 'Workplane based' if @family.workplane_based
    click_on 'Create Family'

    assert_text 'Family was successfully created'
    click_on 'Back'
  end

  test 'updating a Family' do
    visit families_url
    click_on 'Edit', match: :first

    check 'Always vertical' if @family.always_vertical
    fill_in 'Fitting type', with: @family.fitting_type
    fill_in 'Name', with: @family.name
    check 'Room calculation point' if @family.room_calculation_point
    fill_in 'Round dimension', with: @family.round_dimension
    check 'Shared' if @family.shared
    fill_in 'Unique', with: @family.unique_id
    check 'Workplane based' if @family.workplane_based
    click_on 'Update Family'

    assert_text 'Family was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Family' do
    visit families_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Family was successfully destroyed'
  end
end
