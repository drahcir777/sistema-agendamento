class CreateDisponibilidades < ActiveRecord::Migration[8.0]
  def change
    create_table :disponibilidades do |t|
      t.references :user, null: false, foreign_key: true
      t.date :data
      t.time :horario

      t.timestamps
    end
  end
end
