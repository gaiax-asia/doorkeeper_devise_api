class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.string :sender_name, :null => false, :default => ""
      t.string :body, :null => false, :default => ""
      
      t.timestamps
    end
  end
end
