require 'spec_helper'

describe "Autocomplete" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  it "should respond to /autocomplete/style/name"
end
