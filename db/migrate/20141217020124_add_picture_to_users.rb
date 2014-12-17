class AddPictureToUsers < ActiveRecord::Migration
  def self.up
  	add_column :users, :picture_uri, :string
  end
end
