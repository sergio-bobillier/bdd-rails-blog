require 'rails_helper'

RSpec.feature 'Users sign-up' do
  scenario 'With valid credentials' do
    visit '/'

    click_link 'Sign up'

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content('You have signed up successfully.')
  end
end

RSpec.feature 'Users sign-in' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password')
  end

  scenario 'Sign-in with valid credentials' do
    visit '/'

    click_link 'Sign in'

    fill_in 'Email', with: @john.email
    fill_in 'Password', with: @john.password
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content "Signed in as #{@john.email}"
  end
end
