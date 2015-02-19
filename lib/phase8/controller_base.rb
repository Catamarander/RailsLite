require_relative '../phase6/controller_base'
require_relative '../phase9/url_helpers'
require_relative './flash.rb'

module Phase8
  class ControllerBase < Phase6::ControllerBase
    include URLHelpers

    def redirect_to(url)
      super
      flash.store_flash(@res)
    end

    def render_content(content, type)
      super
      flash.store_flash(@res)
    end

    def flash
      @flash ||= Flash.new(@req)
    end
  end
end

req = WEBrick::HTTPRequest.new(Logger: nil)
res = WEBrick::HTTPResponse.new(HTTPVersion: '1.0')
puts Phase8::ControllerBase.new(req, res).methods.sort
