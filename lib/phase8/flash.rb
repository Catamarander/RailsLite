require 'json'
require 'webrick'

module Phase8 #there is no phase 7
  class Flash
    def initialize(req)
      @next = Hash.new{|h, k| h[k] = 0}
      @current = Hash.new{|h, k| h[k] = 0}

      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app_flash'
          JSON.parse(cookie.value).each do |key, val|
            @current[key] = val
          end
        end
      end
    end

    def [](key)
      @next[key] || @current[key]
    end

    def []=(key, val)
      @next[key] = val
    end

    def now
      @current
    end

    def store_flash(res)

      cookie = WEBrick::Cookie.new("_rails_lite_app_flash", @next.to_json)
      res.cookies << cookie
    end


  end
end

#1 Persistent hash
#2 Hash that
