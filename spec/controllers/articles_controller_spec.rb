require 'rails_helper'
require 'support/devise'

RSpec.describe ArticlesController, type: :controller do

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    before do
      @john = User.create!(email: 'john@example.com', password: 'password')
      @fred = User.create!(email: 'fred@example.com', password: 'password')
      @article = Article.create(title: 'The first article', body: 'Body of the first article', user: @john)
    end

    context 'Owner edits one of his own articles' do
      it 'renders the edit template' do
        sign_in @john
        get :edit, params: {id: @article}
        expect(response).to render_template :edit
      end
    end

    context "User tries to edit another user's article" do
      it 'redirects to the root path' do
        sign_in @fred
        get :edit, params: {id: @article}
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq('You can only edit your own articles.')
      end
    end
  end
end
