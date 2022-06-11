class AddUserIdToLabels < ActiveRecord::Migration[6.0]
  def change
    add_reference :labels, :user, freign_key: true
  end
end
