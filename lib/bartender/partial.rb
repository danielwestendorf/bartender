module Bartender
      
  class Partial
    include ViewHelpers

    def initialize(partial, sprockets_env, variables={})
      search_string = File.join(Bartender::DEFAULTS['pages'], '_' + filename + "*")
      file = Dir.glob(search_string)[0]
      if file && File.exists?(file)
        Tilt.new(file).render(variables, variables)
      else
        $stderr.puts "ERROR: Could not find partial file '#{filename}' in #{Bartender::DEFAULTS['pages']} for page #{self.page}"
        exit 0
      end
    end #Function init

  end #Class partial

end #Module Bartender