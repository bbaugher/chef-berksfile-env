require 'chef/environment'
require 'berkshelf'
require 'pathname'

# Ruby metaprogamming, yay!
class Chef
  class Environment

    # @param path path to lock file
    # @raise Berkshelf::LockfileNotFound exception
    def load_berksfile_lock(path=nil)
      lockfile = ::Berkshelf::Lockfile.from_file(path)
      raise ::Berkshelf::LockfileNotFound, "Berks lock file is not present: #{path}" unless lockfile.present?

      lockfile.locks.each_pair do |_, dependency|
        cookbook dependency.name, "= #{dependency.locked_version.to_s}"
      end
    end

    def load_berksfile(path=nil)
      raise "You must define the environment name before doing load_berksfile" if path.nil? && name.empty?
      
      berksfile_path = path.nil? ? "environments/#{name}/Berksfile" : path
      Chef::Log.debug("Using Berksfile path [#{berksfile_path}]")

      begin
        berksfile = ::Berkshelf::Berksfile.new find_berksfile(berksfile_path)

        berksfile.list.each do |dependency|
          cookbook dependency.name, "= #{dependency.locked_version.to_s}"
        end
      rescue ::Berkshelf::LockfileNotFound => e
        raise "Your Berkshelf file [#{path}] has not been locked. Run 'berks install' to lock it"
      end

    end

    private

    def find_berksfile berksfile_path

      if Pathname.new(berksfile_path).absolute?
        validate_berksfile_exists berksfile_path
        return berksfile_path
      end

      execution_dir = Dir.pwd

      berksfile_dirs = berksfile_path.split("/")
      berksfile = berksfile_dirs.pop

      dirs = berksfile_dirs.size

      berksfile_dir = ''

      for i in 0..(berksfile_dirs.size - 1)
        berksfile_dir += berksfile_dirs[i]

        if execution_dir.end_with? berksfile_dir
          path = File.join(execution_dir, *berksfile_dirs[i+1,berksfile_dirs.size], berksfile)
          Chef::Log.debug("Relative berksfile path merges with execution directory at [#{path}]")
          
          validate_berksfile_exists path

          return path
        end

        berksfile_dir += '/'
      end

      # We are pretty much guessing at this point, good luck
      path = File.expand_path(File.join(Dir.pwd, berksfile_path))
      Chef::Log.debug("Guessing Berksfile path to be [#{path}]")

      validate_berksfile_exists path

      path
    end

    def validate_berksfile_exists path
      raise "Expected Berksfile at [#{path}] but does not exist" unless File.exists? path
    end

  end
end