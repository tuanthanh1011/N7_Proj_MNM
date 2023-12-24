class CreateRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :ratings do |t|
      t.integer :RatingCode
      t.integer :RatingStar
      t.text :Description
      t.date :CreatedAt
      t.date :UpdatedAt

      t.timestamps
    end
  end
end
