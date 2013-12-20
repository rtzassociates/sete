class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.integer :upload_id
      t.integer :user_id

      t.timestamps
    end
  end
end
