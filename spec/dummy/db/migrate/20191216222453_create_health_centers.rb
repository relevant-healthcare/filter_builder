class CreateHealthCenters < ActiveRecord::Migration
  def change
    create_table :health_centers do |t|
      t.string :name, null: false
    end
  end
end
