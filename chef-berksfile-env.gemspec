# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "chef-berksfile-env"
  spec.version       = IO.read("VERSION")
  spec.authors       = ["Bryan Baugher"]
  spec.email         = ["bryan.baugher@cerner.com"]
  spec.summary       = "A Chef plugin to lock down your Chef Environment with a Berksfile"
  spec.description   = IO.read("README.md")
  spec.homepage      = "http://github.com/bbaugher/chef-berksfile-env"
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*.rb', 'Gemfile', 'Rakefile', 'README.md', 'VERSION']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "berkshelf", "~> 3.0"
  spec.add_dependency "chef", "~> 11.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 0.9"
  spec.add_development_dependency "octokit", "~> 3.0"
end
