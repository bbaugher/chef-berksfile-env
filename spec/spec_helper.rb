require 'chef-berksfile-env'

module SpecHelper

  def test_env_path
    File.expand_path(File.join(File.dirname(__FILE__), "resources/environments/test_env.rb"))
  end

  def berksfile_path
    'chef-berksfile-env/spec/resources/environments/test_env/Berksfile'
  end

  def berks_install
    Berkshelf::Berksfile.from_file('spec/resources/environments/test_env/Berksfile').install
  end

end
