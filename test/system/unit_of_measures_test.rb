# frozen_string_literal: true

require 'application_system_test_case'

class UnitOfMeasuresTest < ApplicationSystemTestCase
  setup do
    @unit_of_measure = unit_of_measures(:one)
  end

  test 'visiting the index' do
    visit unit_of_measures_url
    assert_selector 'h1', text: 'Unit Of Measures'
  end

  test 'creating a Unit of measure' do
    visit unit_of_measures_url
    click_on 'New Unit Of Measure'

    fill_in 'String', with: @unit_of_measure.string
    click_on 'Create Unit of measure'

    assert_text 'Unit of measure was successfully created'
    click_on 'Back'
  end

  test 'updating a Unit of measure' do
    visit unit_of_measures_url
    click_on 'Edit', match: :first

    fill_in 'String', with: @unit_of_measure.string
    click_on 'Update Unit of measure'

    assert_text 'Unit of measure was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Unit of measure' do
    visit unit_of_measures_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Unit of measure was successfully destroyed'
  end
end
