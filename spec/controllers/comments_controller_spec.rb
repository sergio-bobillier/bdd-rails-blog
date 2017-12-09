require 'rails_helper'
require 'support/devise'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    before do
      @john = User.create!(email: 'john@example.com', password: 'password')
      @article = Article.create(title: 'The first article', body: 'Body of the first article', user: @john)
    end

    context 'Signed in user' do
      it 'can create a comment' do
        sign_in @john
        post :create, params: {article_id: @article.id, comment: {body: 'Awesome post'}}
        expect(flash[:success]).to eq('Comment has been created')
      end
    end

    context 'Non signed in user' do
      it 'is redirected to the sign-in page' do
        post :create, params: {article_id: @article.id, comment: {body: 'Awesome post'}}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
