require 'chef-berksfile-env'

module SpecHelper

  def test_env_path
    File.expand_path(File.join(File.dirname(__FILE__), "resources/environments/test_env.rb"))
  end

end