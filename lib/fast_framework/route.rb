module FastFramework
  module Route

    HTTP_METHODS = [:get, :post]

    def self.extended(base)
    end

    def routes
      @routes ||= {}
    end

    def config
      yield self if block_given?
    end

    def []=(pattern, application)
      store(pattern, application, routes)
    end

    def self.http_methods
      HTTP_METHODS
    end

    def map pattern_and_application_hash
      pattern = pattern_and_application_hash.keys.first
      application = pattern_and_application_hash.values.first

      self[pattern] = application
    end

    def [](pattern)
      routes[pattern]
    end

    def for(application)
      reverse_routes[application]
    end

    protected

    def reverse_routes
      routes.invert
    end

    def store(key, value, hash_store={})
      hash_store[key] = value
    end
  end
end
