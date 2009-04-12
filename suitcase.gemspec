# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{suitcase}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ari Lerner"]
  s.date = %q{2009-04-12}
  s.email = %q{arilerner@mac.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/suitcase.rb",
    "lib/suitcase/unzipper.rb",
    "lib/suitcase/zipper.rb",
    "test/suitcase_test.rb",
    "test/test_dir/box.rb",
    "test/test_dir/test.txt",
    "test/test_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/auser/suitcase}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}
  s.test_files = [
    "test/suitcase_test.rb",
    "test/test_dir/box.rb",
    "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<tarruby>, [">= 0"])
    else
      s.add_dependency(%q<tarruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<tarruby>, [">= 0"])
  end
end
