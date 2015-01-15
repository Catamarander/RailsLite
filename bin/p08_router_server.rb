require 'webrick'
require_relative '../lib/phase8/controller_base'


class MyController < Phase8::ControllerBase
  def go
    flash["notice"] = rand(2)
    flash["test"] = 2 if flash["notice"] == 1
    flash.now["now"] = 7
    render :show
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  MyController.new(req, res).go
end

trap('INT') { server.shutdown }
server.start
