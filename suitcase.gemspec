# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{suitcase}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ari Lerner"]
  s.date = %q{2009-06-15}
  s.email = %q{arilerner@mac.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "VERSION.yml", "lib/suitcase", "lib/suitcase/unzipper.rb", "lib/suitcase/zipper.rb", "lib/suitcase.rb", "test/package.tar.gz", "test/suitcase_test.rb", "test/test_dir", "test/test_dir/box.rb", "test/test_dir/gems", "test/test_dir/gems/famoseagle-carrot-0.6.0.gem", "test/test_dir/test.txt", "test/test_helper.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/auser/suitcase}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<tarruby>, [">= 0"])
    else
      s.add_dependency(%q<tarruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<tarruby>, [">= 0"])
  end
end
