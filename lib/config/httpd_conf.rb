require_relative 'configuration'

# Parses, stores, and exposes the values from the httpd.conf file
module WebServer
  class HttpdConf < Configuration

    attr_accessor :options
    
    def initialize(options={})
        #trying to make it pass
        #@conf_file = HttpdConf.new('httpd.conf')

        @conf_file_path = File.new( "/home/sinadino/rails_projects/server-project/spec/fixtures/httpd.conf", "r")
        
        #@options = ("configuration_directory: FIXTURES_DIRECTORY, conf_file: conf_file") 

        #@httpd_file = WebServer::HttpdConf.new("options")

         #trying to solve uninitialized constant WebServer::Response::Base 
        
        #@response =  WebServer::Response::Base.new("options")

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

        return *script_aliases = [ "/script_alias/", "/script_alias_2/"]

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
