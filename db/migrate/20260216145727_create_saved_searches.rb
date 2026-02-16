class CreateSavedSearches < ActiveRecord::Migration[8.1]
  def change
    create_table :saved_searches do |t|
      t.references :user, null: false, foreign_key: true
      t.string :query
      t.string :brand
      t.string :size
      t.string :color
      t.decimal :min_price
      t.decimal :max_price
      t.string :category
      t.boolean :active
      t.datetime :last_checked_at

      t.timestamps
    end
  end
end
