class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.date :visit_date
      t.boolean :uds_universe
      t.references :patient, index: true
      t.references :provider, index: true

      t.timestamps null: false
    end
  end
end
