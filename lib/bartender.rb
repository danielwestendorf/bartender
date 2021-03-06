require "bartender/version"

require 'rubygems'
require 'yaml'
require 'fileutils'

require 'deep_merge'

require 'bartender/view_helpers'
require 'bartender/asset'
require 'bartender/partial'
require 'bartender/site'
require 'bartender/page'

module Bartender
  DEFAULTS = {
    #default options here

    #path options
    "root"              => "./",          #root for the source
    "output"            => "_site",       #where the site content will be saved
    "layouts"           => "layouts",     #folder where layouts are saved
    "pages"             => "pages",       #folder where actual pages are saved
    "assets"            => "assets",      #folder where un-compiled assets should be 
    "excluded_files"    => [],            #files that shouldn't be compiled

    #site map options
    "site_map_excluded_files"    => []    #exclude these file from the site map, excluded_files automatically included
  }

  def self.configure(cli_options)
    root = Bartender::DEFAULTS["root"]

    config_file = File.join(root, '_config.yml')
    if File.directory?(config_file)
      begin
        config YAML.load_file(config_file)
        $stdout.puts "Configuration from #{config_file}"
      rescue => err
        $stderr.puts "WARNING: Could not read configuration. " +
                     "Using defaults (and options)."
        $stderr.puts "\t" + err.to_s
        config = {}
      end
    else
      config = {}
    end
    Bartender::DEFAULTS.deep_merge(config).deep_merge(cli_options)
  end
end
