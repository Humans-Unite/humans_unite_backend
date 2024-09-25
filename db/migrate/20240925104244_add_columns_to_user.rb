class AddColumnsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :description, :string
    add_column :users, :skills, :text
    add_column :users, :state, :string
    add_column :users, :contact_info, :string
  end
  
end
