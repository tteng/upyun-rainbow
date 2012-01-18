#coding: utf-8
require 'configatron'
require 'rest-client'
require 'domainatrix'
require 'uri'

module UpyunRainbow

  class Util
   
    def initialize bucket=nil, user=nil, pwd=nil, api_host="http://v0.api.upyun.com" 
      @api_host = api_host || configatron.upaiyun.api_host
      @bucket   = bucket   || configatron.upaiyun.bucket_name
      @user     = user     || configatron.upaiyun.user_name
      @password = pwd      || configatron.upaiyun.password
    end

    def get url, options={}
      relative_path = get_relative_path url
      result = process :get, relative_path, options
    end

    def put url, data, options={}
      relative_path = get_relative_path url
      result = process :put, relative_path, data, options
    end

    def post url, data, options={}
      relative_path = get_relative_path url
      result = process :post, relative_path, data, {'Expect' => '', 'Mkdir' => 'true'}.merge(options) 
    end

    def delete url, options={}
      relative_path = get_relative_path url
      result = process :delete, relative_path, options 
    end

    private
    def resource
      @resource ||= RestClient::Resource.new( 
                                              "#{@api_host}/#{@bucket}",
                                              :user => @user,
                                              :password => @password
                                            )
    end

    def escaped_path url
      URI.encode url
    end

    def get_relative_path url
      begin
        relative_path = Domainatrix.parse(escaped_path(url)).path
      rescue
        raise "Not a regular http path to process, the url should looks like http://yourdomain.com/file/to/process.jpg|txt"
      end
      raise "Oh, Which file to process?" if relative_path.blank? 
      relative_path
    end

    def process meth, url, data=nil, options={}
      proc = Proc.new do |response, request, result|
        case response.code
          when 200
            [:ok, 200]
          else
            [:error, response.code]
        end
      end
      result = [:post, :put].include?(meth) ? resource[url].send(meth, data, options, &proc) : resource[url].send(meth, options, &proc) 
    end

  end

end
