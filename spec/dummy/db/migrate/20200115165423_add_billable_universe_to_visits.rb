class AddBillableUniverseToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :billable_universe, :boolean, default: true
  end
end
