# -*- encoding: utf-8 -*-
# stub: debase-ruby_core_source 0.10.12 ruby lib

Gem::Specification.new do |s|
  s.name = "debase-ruby_core_source".freeze
  s.version = "0.10.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mark Moseley".freeze, "Gabriel Horner".freeze, "JetBrains RubyMine Team".freeze]
  s.date = "2021-01-12"
  s.description = "Provide Ruby core source files for C extensions that need them.".freeze
  s.email = "os97673@gmail.com".freeze
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze]
  s.homepage = "http://github.com/os97673/debase-ruby_core_source".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.0.3.1".freeze
  s.summary = "Provide Ruby core source files".freeze

  s.installed_by_version = "3.0.3.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<archive-tar-minitar>.freeze, [">= 0.5.2"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 0.9.2"])
      s.add_development_dependency(%q<minitar-cli>.freeze, [">= 0"])
    else
      s.add_dependency(%q<archive-tar-minitar>.freeze, [">= 0.5.2"])
      s.add_dependency(%q<rake>.freeze, ["~> 0.9.2"])
      s.add_dependency(%q<minitar-cli>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<archive-tar-minitar>.freeze, [">= 0.5.2"])
    s.add_dependency(%q<rake>.freeze, ["~> 0.9.2"])
    s.add_dependency(%q<minitar-cli>.freeze, [">= 0"])
  end
end
