require 'tilt'

module Bartender
  
  class Page
    attr_reader :config, :page, :data, :content, :output

    def initialize(page)
      @page = page
      return false unless File.exists?(@page) #does the page actual exist?
      @data = File.read(@page)
      self.read_yaml
      @klass = Tilt[page]
    end #Funciton initialize

    def compile
      output_path = @page.split('/')
      output_path[0] = File.join(Bartender::DEFAULTS['root'], Bartender::DEFAULTS['output'])
      file_name = output_path[-1].split('.')
      file_name.delete_at(-1)
      output_path[-1] = file_name.join('.')
      @output = output_path.join('/')
      File.delete @output if File.exists? @output
      File.open(@output, 'w') {|f| f.write self.render}
    end #Funciton compile

    def render
      return nil if @klass.nil? #make sure tilt knows what to render, otherwise return nil
      template = @klass.new {@content}
      compiled = template.render(self)
      if self.layout_specified?
        layout = Tilt.new self.find_layout
        return layout.render(self) {compiled}
      else
        return compiled
      end
    end #Function render

    def find_layout
      layouts = Dir.glob(Bartender::DEFAULTS['root'] + Bartender::DEFAULTS['layouts'] + "/#{self.layout}.*")
      if layouts.length > 0
        return layouts[0]
      else
        $stderr.puts "ERROR: Could not find layout file '#{self.layout}' in #{Bartender::DEFAULTS['root'] + Bartender::DEFAULTS['layouts']} for page #{@page} "
        exit 0
      end
    end #Function find_layout

    def layout_specified?
     self.layout
    end

    def read_yaml
      begin
        if @data =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          @config = YAML.load($1)
          @config.each_key do |k|
            instance_variable_set ('@'<<k).to_sym, @config[k]
          end
          @content = @data
          @content.gsub!(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m, '')
        end
      rescue => e
        puts "YAML Exception reading #{@page}: #{e.message}"
      end
    end #Function read_yaml

    def method_missing(m, *args)
      if m =~ /^(\w+)=$/
        instance_variable_set "@#{$1}", args[0]
      else
        instance_variable_get "@#{m}"
      end
    end #Funciton method_missing

  end #Class Page

end #Module Bartender