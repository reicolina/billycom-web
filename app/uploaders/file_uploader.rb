class FileUploader < CarrierWave::Uploader::Base

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include CarrierWaveDirect::Uploader
  include CarrierWave::MimeTypes
  
  process :set_content_type

  def store_dir
    "uploads/" + Rails.env.to_s + "/#{model.class.to_s.underscore}/" + ActsAsTenant.current_tenant.name.to_s.gsub(/[^0-9A-Za-z]/, '')
  end

  # When the move_to_cache and/or move_to_store methods return true, files will be moved (instead of copied) to the cache and store respectively.
  def move_to_cache
    true
  end
  def move_to_store
    true
  end

end