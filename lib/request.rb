# The Request class encapsulates the parsing of an HTTP Request

require 'socket'
require 'uri'

require_relative '../lib/config/httpd_conf'
require_relative '../lib/request'
require_relative '../lib/response'


module WebServer
  class Request
    attr_accessor :http_method, :uri, :version, :headers, :body, :params, :socket

    attr_accessor :http_methods

    # Request creation receives a reference to the socket over which
    # the client has connected
    def initialize(socket)
      @socket = socket
      @http_methods = [ 'GET', 'POST', 'PUT', 'HEAD']
      @headers = {}
      @params = {}
      @body = ""
      parse
    end



    # I've added this as a convenience method, see TODO (This is called from the logger
    # to obtain information during server logging)
    def user_id
      # TODO: This is the userid of the person requesting the document as determined by 
      # HTTP authentication. The same value is typically provided to CGI scripts in the 
      # REMOTE_USER environment variable. If the status code for the request (see below) 
      # is 401, then this value should not be trusted because the user is not yet authenticated.
      '-'
    end

    # Parse the request from the socket - Note that this method takes no
    # parameters
    def parse

      @headers['CONTENT_LENGTH'] = 0

      while line = @socket.gets
        break if line == "\r\n"
        parse_header line
      end

    end



    def parse_header(header_line)

      split_line = header_line.split " "

      if (@http_methods.include? split_line[0])
        @http_method = split_line[0]

        uri = URI(split_line[1])
        @uri = uri.path


        uri.query.split("&").each do |param|
          param = param.split("=")
          @params[param[0]] = param[1]
        end unless uri.query == nil

        @version = split_line[2]
      elsif split_line[0] == "Host:"
        headers['HOST'] = split_line[1]
      elsif split_line[0] == "Content-Length:"
        @headers['CONTENT_LENGTH'] = split_line[1]
      end

    end

    # This method is purely for the purpose of debugging.
    def to_s
      output = "--------------------------------\n"

      output += "#{@http_method} #{@uri} #{@version}\n"

      @headers.keys.each do |header|
        output += "#{header}: #{@headers[header]}\n"
      end

      output += "\n"

      unless @body.nil?
        output += "#{@body}\n"
      end

      output += "--------------------------------\n"

      puts output
    end

    def parse_body(body_line)
      #@body << body_line.gsub("\n",'')
    end

    def parse_params
    end
  end
end

#FIXTURES_DIRECTORY = File.join File.dirname(__FILE__), '../spec/fixtures'
#
#file =  File.new("#{FIXTURES_DIRECTORY}/basic_get.txt", 'r')
#
#abc = WebServer::Request.new (file)
#puts abc.to_s