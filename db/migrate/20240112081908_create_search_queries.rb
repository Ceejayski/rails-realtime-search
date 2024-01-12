class CreateSearchQueries < ActiveRecord::Migration[7.0]
  def change
    create_table :search_queries do |t|
      t.string :text
      t.string :user_ip
      t.index :user_ip

      t.timestamps
    end
  end
end
