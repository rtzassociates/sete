# encoding: utf-8

class AssetUploader < CarrierWave::Uploader::Base
  
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :file

  def store_dir
    "#{Rails.root}/uploads/#{model.id}"
  end

end
