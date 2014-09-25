require 'chef-berksfile-env'

name "test_env"

description "a description"

load_berksfile

default_attributes({"a" => "b"})

override_attributes({"c" => "d"})