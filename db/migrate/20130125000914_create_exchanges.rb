class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.integer :allowed_id
      t.integer :allowing_id
      t.timestamps
    end
  end
end
