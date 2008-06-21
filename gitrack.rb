require 'rack/lib/rack'
require 'simplegit/lib/simplegit'

class GitRack
  def call(env)
    [200, {'Content-type' => 'text/plain'},
      git_files_list]
  end
  
  def git_files_list
    SimpleGit.new('.git').log('master', 2)
  end
end

app = Rack::Builder.new {
  use Rack::CommonLogger, STDERR
  run GitRack.new
}.to_app

server = Rack::Handler::WEBrick
options = {:Port => 9292, :Host => "0.0.0.0"}
server.run app, options