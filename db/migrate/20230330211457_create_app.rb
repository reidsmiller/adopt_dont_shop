class CreateApp < ActiveRecord::Migration[5.2]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.text :description
      t.string :status, default: 'In Progress'

      t.timestamps
    end
  end
end
