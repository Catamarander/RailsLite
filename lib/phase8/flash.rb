require 'json'
require 'webrick'

module Phase8 #there is no phase 7
  class Flash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app_flash'
          @cookie = JSON.parse(cookie.value)
        end
      end

      @cookie ||= {}
    end

    def [](key)
      @cookie[key]
    end

    def []=(key, val)
      @cookie[key] = val
    end

    def store_flash(res)
      # This flash information is persistent, and not temporary
      # NOT what we want!
      cookie = WEBrick::Cookie.new("_rails_lite_app_flash", @cookie.to_json)
      res.cookies << cookie
    end

  end
end
