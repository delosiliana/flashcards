class AddUserIdToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :user_id, :integer
  end
end
