class ChangeColumnNullTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :title, :string, null: false
  end
end
