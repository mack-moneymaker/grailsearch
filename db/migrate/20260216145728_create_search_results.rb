class CreateSearchResults < ActiveRecord::Migration[8.1]
  def change
    create_table :search_results do |t|
      t.references :saved_search, null: false, foreign_key: true
      t.string :platform
      t.string :title
      t.decimal :price
      t.string :currency
      t.string :url
      t.string :image_url
      t.string :seller
      t.string :condition
      t.string :external_id
      t.datetime :listed_at

      t.timestamps
    end
  end
end
