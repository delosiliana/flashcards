class AddPictureToCards < ActiveRecord::Migration[5.2]
  def up
    add_attachment :cards, :picture
  end

  def down
    remove_attachment :cards, :picture
  end
end
