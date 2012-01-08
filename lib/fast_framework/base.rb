require 'json'
module FastFramework
  module Base
    extend self

    CONTENT_TYPE_HEADER = 'Content-Type'
    CONTENT_MAP = {
      :html => 'text/html',
      :text => 'text/plain',
      :json => 'application/json',
      :js => 'application/javascript'
    }
    STATUS_MAP = {
      :success => 200,
      :fail => 404,
      :error => 500
    }

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def call(_env)
        new(_env).call
      end
    end

    attr_reader :env
    def initialize(_env)
      @env = _env
      self.status = :error
      @debug = false
      yield self if block_given?
    end

    def log &block
      FastFramework.log &block
    end

    def debug
      FastFramework.debug
    end

    def default_headers
      type = request_path.split('.').last.to_sym
      self.headers = content_type(type) ? type : :text
    end

    def call
      default_headers
      respond_to?(request_method) ? body : ["unhandled request method: #{request_method.inspect}"]
      [ status, headers, body ].tap do |response|
        log { "response: #{response.inspect}" }
      end
    end

    def get
      status=(:fail)
      ['page not found']
    end
    alias :post :get

    def request_method
      @request_method ||= env["REQUEST_METHOD"].downcase
    end

    def headers=(header_type)
      @headers = content_header(header_type)
    end

    def headers
      @headers
    end

    def status
      @status
    end

    def status=(code)
      @status = lookup_status(code)
    end

    def lookup_status(code)
      STATUS_MAP[code]
    end

    def content_type(type)
      CONTENT_MAP[type]
    end

    def content_header(type)
      {CONTENT_TYPE_HEADER => content_type(type)}
    end

    protected

    # TODO: compress response, when
    # "HTTP_ACCEPT_ENCODING"=>"gzip, deflate"
    def body
      @body ||= send(request_method)
    end

    def request_path
      @request_path ||= env["REQUEST_PATH"].downcase
    end

    # HTML Output:
    def button(value)
      %Q{<input type='submit' value='#{value}'>}
    end

    def form(action)
      %Q{<form action='#{action}'>}.tap do |_form|
        _form << yield if block_given?
        _form << %Q{</form>}
      end
    end
  end
end
