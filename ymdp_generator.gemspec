# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ymdp_generator}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Coleman"]
  s.date = %q{2010-03-15}
  s.description = %q{Generates new views, JavaScripts, stylesheets and translation assets for Yahoo! Mail Development Platform applications.}
  s.email = %q{progressions@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "History.txt",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/view.rb",
     "lib/ymdp_generator.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/ymdp_generator_spec.rb",
     "ymdp_generator.gemspec"
  ]
  s.homepage = %q{http://github.com/progressions/ymdp_generator}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Generates new views and assets for YMDP applications.}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/ymdp_generator_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.6"])
      s.add_runtime_dependency(%q<f>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.6"])
      s.add_dependency(%q<f>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.6"])
    s.add_dependency(%q<f>, [">= 0"])
  end
end

