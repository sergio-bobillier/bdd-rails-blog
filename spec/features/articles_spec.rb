require 'rails_helper'

RSpec.feature 'Listing articles' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password')
    @article1 = Article.create(title: 'The first article', body: 'Body of the first article', user: @john)
    @article2 = Article.create(title: 'The second article', body: 'Body of the second article', user: @john)
  end

  scenario 'A user lists the articles' do
    visit '/'

    expect(page).to have_content(@article1.title)
    expect(page).to have_content(@article1.body)
    expect(page).to have_content(@article2.title)
    expect(page).to have_content(@article2.body)

    expect(page).to have_link(@article1.title)
    expect(page).to have_link(@article2.title)

    expect(page).not_to have_link('New Article')
  end
end

RSpec.feature 'Showing articles' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password')
    @fred = User.create!(email: 'fred@example.com', password: 'password')
    @article = Article.create(title: 'The first article', body: 'Body of the first article', user: @john)
  end

  scenario 'A non signed-in user clicks an article link' do
    visit '/'

    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(page.current_path).to eq(article_path(@article))

    expect(page).not_to have_link('Edit Article')
    expect(page).not_to have_link('Delete Article')
  end

  scenario "A signed-in user clicks another user's article link" do
    login_as(@fred)

    visit '/'

    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(page.current_path).to eq(article_path(@article))

    expect(page).not_to have_link('Edit Article')
    expect(page).not_to have_link('Delete Article')
  end

  scenario "A signed-in user clicks his/her own article link" do
    login_as(@john)

    visit '/'

    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(page.current_path).to eq(article_path(@article))

    expect(page).to have_link('Edit Article')
    expect(page).to have_link('Delete Article')
  end
end

RSpec.feature 'Creating Articles' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password')
    login_as(@john)
  end

  scenario 'A user creates a new article' do
    visit '/'

    click_link 'New Article'

    fill_in 'Title', with: 'Creating first article'
    fill_in 'Body', with: 'Lorem ipsum dolor set amet'
    click_button 'Save'

    expect(page).to have_content('Article has been created')
    expect(page.current_path).to eq(articles_path)
    expect(page).to have_content("Created by: #{@john.email}")
  end

  scenario 'A user fails to create a new article' do
    visit '/'

    click_link 'New Article'

    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_button 'Save'

    expect(page).to have_content('Article has not been created')
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Body can't be blank")
  end
end

RSpec.feature 'Editing articles' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password')
    login_as(@john)

    @article = Article.create(title: 'The first article', body: 'Body of the first article', user: @john)
  end

  scenario 'A user edits an article' do
    visit '/'

    click_link @article.title
    click_link 'Edit Article'

    fill_in 'Title', with: 'Updated article'
    fill_in 'Body', with: 'Updated body of article'
    click_button 'Save'

    expect(page).to have_content('Article has been updated')
    expect(page.current_path).to eq(article_path(@article))
  end

  scenario 'A user fails to update an article' do
    visit '/'

    click_link @article.title
    click_link 'Edit Article'

    fill_in 'Title', with: ''
    fill_in 'Body', with: 'Updated body of article'
    click_button 'Save'

    expect(page).to have_content('Article has not been updated')
    expect(page.current_path).to eq(article_path(@article))
  end
end

RSpec.feature 'Deleting articles' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password')
    login_as(@john)

    @article = Article.create(title: 'The first article', body: 'Body of the first article', user: @john)
  end

  scenario 'A user deletes an article' do
    visit '/'

    click_link @article.title
    click_link 'Delete Article'

    expect(page).to have_content('Article has been deleted')
    expect(page.current_path).to eq(articles_path)
  end

  scenario 'A user fails to delete an article' do
  end
end
