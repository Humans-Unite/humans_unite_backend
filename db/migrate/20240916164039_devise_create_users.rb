# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :type  
      t.string :city

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :type              
  end
end
