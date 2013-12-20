class AddAssetToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :asset, :string
  end
end
