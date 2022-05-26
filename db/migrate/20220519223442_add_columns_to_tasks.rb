class AddColumnsToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :deadline_on, :date, null: false
    add_column :tasks, :priority, :integer, null: false, default: ""
    add_column :tasks, :status, :integer, null: false, default: ""
  end
end
