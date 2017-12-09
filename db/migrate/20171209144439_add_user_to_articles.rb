class AddUserToArticles < ActiveRecord::Migration[5.1]
  def change
    add_reference :articles, :user, index: true
    add_foreign_key :articles, :users
  end
end
