class AddTwelveMonthPanelTargetToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :twelve_month_panel_target, :numeric
  end
end
