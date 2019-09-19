class AddCurrentToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :current, :boolean
  end
end
