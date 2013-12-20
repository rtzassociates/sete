class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :user_id
      t.integer :upload_id

      t.timestamps
    end
  end
end
