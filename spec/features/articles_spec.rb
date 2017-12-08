require 'rails_helper'

RSpec.feature 'Listing articles' do
  before do
    @article1 = Article.create(title: 'The first article', body: 'Body of the first article')
    @article2 = Article.create(title: 'The second article', body: 'Body of the second article')
  end

  scenario 'A user lists the articles' do
    visit '/'

    expect(page).to have_content(@article1.title)
    expect(page).to have_content(@article1.body)
    expect(page).to have_content(@article2.title)
    expect(page).to have_content(@article2.body)

    expect(page).to have_link(@article1.title)
    expect(page).to have_link(@article2.title)
  end
end

RSpec.feature 'Showing articles' do
  before do
    @article = Article.create(title: 'The first article', body: 'Body of the first article')
  end

  scenario 'A user clicks an article link' do
    visit '/'

    click_link @article.title

    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to eq(article_path(@article))
  end
end

RSpec.feature 'Creating Articles' do
  scenario 'A user creates a new article' do
    visit '/'

    click_link 'New Article'

    fill_in 'Title', with: 'Creating first article'
    fill_in 'Body', with: 'Lorem ipsum dolor set amet'
    click_button 'Save'

    expect(page).to have_content('Article has been created')
    expect(page.current_path).to eq(articles_path)
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
