require 'rails_helper'

describe 'building a filter form', type: :feature do
  let!(:carmen) do
    Fabricate(
      :patient,
      first_name: 'Carmen',
      last_name: 'San Diego',
      date_of_birth: Date.new(1991, 10, 31),
      visits: [carmen_visit],
      provider: carmen_provider
    )
  end
  let!(:carmen_visit) do
    Fabricate(
      :visit,
      visit_date: Date.new(2017, 11, 25),
      provider: carmen_visit_provider
    )
  end
  let!(:carmen_provider) do
    Fabricate(
      :provider,
      npi: 'dorayme'
    )
  end
  let!(:carmen_visit_provider) do
    Fabricate(
      :provider,
      npi: 'fasolatee'
    )
  end
  let!(:malcom) do
    Fabricate(
      :patient,
      first_name: 'Malcom',
      last_name: 'Avalon',
      date_of_birth: Date.new(1993, 5, 26)
    )
  end

  it 'renders all patients by without filtering' do
    visit patients_path
    expect(page).to have_content 'Carmen San Diego'
    expect(page).to have_content 'Malcom Avalon'
  end

  it 'can filter by text field' do
    visit patients_path

    fill_in 'filter_first_name', with: 'Carmen'
    click_button 'Filter'
    expect(page).to have_content 'Carmen San Diego'
    expect(page).not_to have_content 'Malcom Avalon'
    expect(find_field('filter_first_name').value).to eq 'Carmen'

    fill_in 'filter_first_name', with: ''
    click_button 'Filter'

    expect(page).to have_content 'Carmen San Diego'
    expect(page).to have_content 'Malcom Avalon'
  end

  it 'can filter by date field' do
    visit patients_path

    fill_in 'filter_date_of_birth', with: '1991-10-31'
    click_button 'Filter'
    expect(page).to have_content 'Carmen San Diego'
    expect(page).not_to have_content 'Malcom Avalon'
    expect(find_field('filter_date_of_birth').value).to eq '1991-10-31'

    fill_in 'filter_date_of_birth', with: ''
    click_button 'Filter'

    expect(page).to have_content 'Carmen San Diego'
    expect(page).to have_content 'Malcom Avalon'
  end

  it 'can filter by collection select' do
    visit patients_path
    select 'dorayme', from: 'filter_provider_id'
    click_button 'Filter'
    expect(page).to have_content 'Carmen San Diego'
    expect(page).not_to have_content 'Malcom Avalon'
    expect(find_field('filter_provider_id').value).to eq [carmen_provider.id.to_s]

    unselect 'dorayme', from: 'filter_provider_id'
    click_button 'Filter'

    expect(page).to have_content 'Carmen San Diego'
    expect(page).to have_content 'Malcom Avalon'
  end

  it 'can filter through an association' do
    visit patients_path
    fill_in 'filter_visits_date_on_or_before', with: '2017-11-25'
    click_button 'Filter'

    expect(page).to have_content 'Carmen San Diego'
    expect(page).not_to have_content 'Malcom Avalon'

    expect(find_field('filter_visits_date_on_or_before').value).to eq '2017-11-25'

    fill_in 'filter_visits_date_on_or_before', with: ''
    click_button 'Filter'

    expect(page).to have_content 'Carmen San Diego'
    expect(page).to have_content 'Malcom Avalon'
  end

  it 'can filter through a nested association' do
    visit patients_path
    fill_in 'filter_visits_provider_npi', with: 'fasolatee'
    click_button 'Filter'

    expect(page).to have_content 'Carmen San Diego'
    expect(page).not_to have_content 'Malcom Avalon'

    expect(find_field('filter_visits_provider_npi').value).to eq(
      'fasolatee'
    )

    fill_in 'filter_visits_provider_npi', with: ''
    click_button 'Filter'

    expect(page).to have_content 'Carmen San Diego'
    expect(page).to have_content 'Malcom Avalon'
  end
end
