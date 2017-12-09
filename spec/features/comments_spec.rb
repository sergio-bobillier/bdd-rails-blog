require 'rails_helper'

RSpec.feature 'Add comments to articles' do
  before do
    @john = User.create!(email: 'john@example.com', password: 'password')
    @fred = User.create!(email: 'fred@example.com', password: 'password')
    @article = Article.create(title: 'The first article', body: 'Body of the first article', user: @john)
  end

  scenario 'Signed-in user writes a comment' do
    login_as @fred

    visit '/'
    click_link @article.title
    fill_in 'New Comment', with: 'An awesome article'
    click_button 'Add Comment'

    expect(page).to have_content 'Comment has been created'
    expect(page).to have_content 'An awesome article'
    expect(page.current_path).to eq(article_path(@article.comments.last.id))
  end
end
