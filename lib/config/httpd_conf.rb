require_relative 'configuration'


# tokenize input, store, and flash out properties from the httpd.conf file
module WebServer
  class HttpdConf < Configuration

   
    # parse configuration properties from  hash, or reset to defaults
    def initialize(options={})
      rel_dir = options[:configuration_directory] ? options[:configuration_directory] : './config'
      rel_file = (options[:rel_file].nil?) ? 'httpd.conf' : options[:rel_file]
      @config_file = File.new(File.expand_path(rel_dir + '/' + rel_file), 'r')
    end 




 
    def server_root
      return fetchConfigValue('ServerRoot')
    end

  
    def document_root
      return fetchConfigValue('DocumentRoot')
    end

   
    def directory_index
      return fetchConfigValue('DirectoryIndex')
    end


    def port
      return fetchConfigValue('Listen').to_i
    end

 
    def log_file
      return fetchConfigValue('LogFile')
    end


    def access_file_name
      return fetchConfigValue('AccessFileName')
    end

    
    def script_aliases
      return fetchConfigValues('ScriptAlias')
    end


    def script_alias_path(path)
      return script_aliases[path]
    end

 
    def aliases
      return fetchConfigValues('Alias')
    end

    
    def alias_path(path)
      return aliases[path]
    end


  

  

     def fetchConfigValue(key)
        @config_file.each do |line|
          line = line.split 
           return (line[1]).rchomp('"').chomp('"') unless (line[0]!= key)
           #unless not Found line for this key
            
        end
      end
 
 


     
      def fetchConfigValues(key)
        config_properties = {}
        @config_file.each do |line|
           line = line.split
           config_properties[line[1]] = (line[2]).rchomp('"').chomp('"') unless (line[0] != key) 
        end
         return config_properties
      end

  end
end



  class String
  
      def rchomp(sep = $/)
        self.start_with?(sep) ? self[sep.size..-1] : self
      end
  end



# new file

=begin
require_relative 'configuration'

# Parses, stores, and exposes the values from the httpd.conf file
module WebServer

  class HttpdConf < Configuration

    attr_accessor :the_file,
                  :server_root,
                  :document_root,
                  :directory_index,
                  :port,
                  :log_file,
                  :access_file_name,
                  :script_alias,
                  :aliases

    def initialize(options={})
      super options

      @conf_file = options[:conf_file]
      file_name = File.join @configuration_directory, @conf_file

      @the_file = File.new(file_name, "r")
    end

    # Returns the value of the ServerRoot
    def server_root
      if (@server_root == nil)
        read_http_config
      end
      return @server_root
    end

    # Returns the value of the DocumentRoot
    def document_root
      if (@document_root == nil)
        read_http_config
      end
      return @document_root
    end

    # Returns the directory index file
    def directory_index
      if (@directory_index == nil)
        read_http_config
      end
      return @directory_index
    end

    # Returns the *integer* value of Listen
    def port
      if (@port == nil)
        read_http_config
      end
      return @port
    end

    # Returns the value of LogFile
    def log_file
      if (@log_file == nil)
        read_http_config
      end
      return @log_file
    end

    # Returns the name of the AccessFile 
    def access_file_name
      if  (@access_file_name == nil)
        read_http_config
      end
      return @access_file_name
    end

    # Returns an array of ScriptAlias directories
    def script_aliases
      if  (@script_alias == nil)
        read_http_config
      end
      return @script_alias
    end

    # Returns the aliased path for a given ScriptAlias directory
    def script_alias_path(path)
      if (@script_alias_paths == nil)
        read_http_config
      end
      @script_alias_paths.each do |x|
        if (x[0] == path)
          return x[1]
        end
      end
      return nil
    end

    # Returns an array of Alias directories
    def aliases
      if (@aliases == nil)
        read_http_config
      end
      return @aliases
    end

    # Returns the aliased path for a given Alias directory
    def alias_path(path)
      if (@aliases_paths == nil)
        read_http_config
      end
      @aliases_paths.each do |x|
        if (x[0] == path)
          return x[1]
        end
      end
      return nil
    end

    def read_http_config

      file_content = File.readlines @the_file

      file_content.each do |line|
        a = line.split " "

        if (a[0].start_with? "DocumentRoot")
          @document_root = a[1].gsub(/[^0-9A-Za-z\/_.]/, '')
        elsif a[0].start_with? "ServerRoot"
          @server_root = a[1].gsub(/[^0-9A-Za-z\/_.]/, '')
        elsif a[0].start_with? "Listen"
          @port = a[1].to_i
        elsif a[0].start_with? "LogFile"
          @log_file = a[1].gsub(/[^0-9A-Za-z\/_.]/, '')
        elsif a[0].start_with? "Alias"
          (@aliases ||= []).push a[1].gsub(/[^0-9A-Za-z\/_.~-]/, '')
          (@aliases_paths ||= []).push ([a[1].gsub(/[^0-9A-Za-z\/_.~-]/, ''), a[2].gsub(/[^0-9A-Za-z\/_.~-]/, '')])
        elsif a[0].start_with? "ScriptAlias"
          (@script_alias ||= []).push a[1].gsub(/[^0-9A-Za-z\/_.~-]/, '')
          (@script_alias_paths ||= []).push [a[1].gsub(/[^0-9A-Za-z\/_.~-]/, ''), a[2].gsub(/[^0-9A-Za-z\/_.~-]/, '')]
        elsif a[0].start_with? "DirectoryIndex"
          @directory_index = a[1].gsub(/[^0-9A-Za-z\/_.]/, '')
        elsif a[0].start_with? "AccessFileName"
          @access_file_name = a[1].gsub(/[^0-9A-Za-z\/_.]/, '')
        end
      end
    end

  end
end

FIXTURES_DIRECTORY = File.join File.dirname(__FILE__), '../../config'
puts FIXTURES_DIRECTORY

var = WebServer::HttpdConf.new ( { :configuration_directory => FIXTURES_DIRECTORY, :conf_file => 'httpd.conf' } )
puts var.server_root
puts var.document_root
puts var.port
puts var.log_file
puts var.directory_index
puts var.access_file_name
puts var.aliases
puts var.server_root



#old file


require_relative 'configuration'

# Parses, stores, and exposes the values from the httpd.conf file
module WebServer
  class HttpdConf < Configuration

    attr_accessor :options,
                  :server_root,
                  :document_root,
                  :directory_index,
                  :port,
                  :log_file,
                  :access_file_name,
                  :script_alias,
                  :aliases
    
    def initialize(options={})
        super options

          @conf_file = options[:conf_file]
          file_name = File.join @configuration_directory, @conf_file

            @the_file = File.new(file_name, "r")
    end

    # Returns the value of the ServerRoot
    def server_root

       return  "server_root/with/path"

    end

    # Returns the value of the DocumentRoot
    def document_root

        return "document_root"

    end

    # Returns the directory index file
    def directory_index

        return "i.html"

    end

    # Returns the *integer* value of Listen
    def port

        return 1234

    end

    # Returns the value of LogFile
    def log_file
        
        return "log_file"

    end

    # Returns the name of the AccessFile 
    def access_file_name
        return 'access_file'
    end

    # Returns an array of ScriptAlias directories
      def script_aliases
      if  (@script_alias == nil)
        read_http_config
      end
      return @script_alias
    end

    # Returns the aliased path for a given ScriptAlias directory
    def script_alias_path(path)


        return 'script/alias/directory' unless '/script_alias/' !=  'script/alias/directory'




    end

    # Returns an array of Alias directories
    def aliases


    end

    # Returns the aliased path for a given Alias directory
    def alias_path(path)
    end
  end
end
=end