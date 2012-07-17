module Bartender
      
  class Asset
    attr_reader :site_path, :src_file, :digest, :mtime, :file, :dest_path, :sprockets_object, :found

    def initialize(file, sprockets_env)
      @sprockets_object = sprockets_env[file]
      if @sprockets_object
        @found = true
        split_file_name = file.split("/")
        @file = split_file_name[-1]                                         # asset
        @site_path = @sprockets_object.digest_path                          # folder/asset-digest.ext
        @src_file = @sprockets_object.pathname                              # site/asset-folder/asset.ext
        @dest_path = File.join(Bartender::DEFAULTS["output"], site_path)    # output/folder/asset-digest.ext
      else
        @found = false #asset doesn't exist, return nothing
      end
    end #Function init

  end #Class Asset

end #Module Bartender