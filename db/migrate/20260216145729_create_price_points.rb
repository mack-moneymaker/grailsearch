class CreatePricePoints < ActiveRecord::Migration[8.1]
  def change
    create_table :price_points do |t|
      t.string :query
      t.string :brand
      t.string :platform
      t.decimal :average_price
      t.decimal :min_price
      t.decimal :max_price
      t.integer :result_count
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
