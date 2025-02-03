class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.string :name
      t.text :description
      t.integer :duration

      t.timestamps
    end
  end
end
