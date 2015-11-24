require File.expand_path('../spec_helper', __FILE__)
include SpecHelper

describe Chef::Environment do

  before(:all) do
    berks_install
  end

  describe "#load_berksfile" do

    let(:env) do
      env = Chef::Environment.new

      env.name "test_env"
      env.description "a description"

      env.default_attributes "a" => "b"
      env.override_attributes "c" => "d"

      env.cookbook "java", "= 1.28.0"
      env.cookbook "apache_zookeeper", "= 0.3.2"

      env
    end

    describe "from #instance_eval" do
      it "should add the Berksfile dependencies" do
        Dir.chdir "spec/resources" do
          test_env = Chef::Environment.new
          test_env.instance_eval(IO.read(test_env_path))

          expect(test_env.name).to eq env.name
          expect(test_env.description).to eq env.description
          expect(test_env.default_attributes).to eq env.default_attributes
          expect(test_env.override_attributes).to eq env.override_attributes
          expect(test_env.cookbook_versions).to eq env.cookbook_versions
        end
      end
    end

    describe "with relative path" do

      describe "while executing in root dir of relative path" do
        it "should add the Berksfile dependencies" do
          test_env = Chef::Environment.new
          test_env.load_berksfile berksfile_path

          expect(test_env.cookbook_versions).to eq env.cookbook_versions
        end
      end

      describe "while executing next to Berksfile" do
        it "should add the Berksfile dependencies" do
          Dir.chdir "spec/resources" do
            test_env = Chef::Environment.new
            test_env.load_berksfile berksfile_path

            expect(test_env.cookbook_versions).to eq env.cookbook_versions
          end
        end
      end

      describe "whose Berksfile does not exist" do
        it "should raise an error" do
          test_env = Chef::Environment.new
          expect { test_env.load_berksfile "Berksfile" }.to raise_error RuntimeError

        end
      end

    end

    describe "with an absolute path" do
      it "should add the Berksfile dependencies" do
        test_env = Chef::Environment.new
        test_env.load_berksfile File.join(File.dirname(__FILE__), "resources", "environments", "test_env", "Berksfile")

        expect(test_env.cookbook_versions).to eq env.cookbook_versions
      end
    end

  end

end
