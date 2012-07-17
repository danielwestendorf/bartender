module Bartender
      
  class Asset
    attr_reader :site_path, :src_file, :digest, :mtime, :file, :dest_path, :sprockets_object, :found

    def initialize(file, sprockets_env)
      @sprockets_object = sprockets_env[file]
      if @sprockets_object
        @found = true
        split_file_name = file.split("/")
        @file = split_file_name[-1]                                                             # asset
        @site_path = "#{@sprockets_object.logical_path}?#{@sprockets_object.digest}"            # folder/asset.ext?digest
        @src_file = @sprockets_object.pathname                                                  # asset-folder/asset.ext
        @dest_path = File.join(Bartender::DEFAULTS["output"], @sprockets_object.logical_path)   # output/folder/asset.ext
      else
        @found = false #asset doesn't exist, return nothing
      end
    end #Function init

  end #Class Asset

end #Module Bartender