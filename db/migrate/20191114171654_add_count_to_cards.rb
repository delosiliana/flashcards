class AddCountToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :try_count, :integer, default: 0
    add_column :cards, :false_count, :integer, default: 0
  end
end
