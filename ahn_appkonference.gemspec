COMPONENT_FILES = %w{
  ahn_appkonference.gemspec
  CHANGELOG
  LICENSE
  Rakefile
  lib/adhearsion/discovery.rb
  lib/appkonference.rb
}

Gem::Specification.new do |s|
  s.name = "ahn_appkonference"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Klang"]

  s.date = "2010-08-16"
  s.description = "A componenet for the Adhearsion framework to bring extra functionality to users of AppKonference (http://appkonference.sf.net)"
  s.email = "bklang&verendus.com"

  s.files = COMPONENT_FILES

  s.has_rdoc = false
  s.homepage = "http://adhearsion.com"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.2.0"
  s.summary = "A component for Adhearsion, the open source telephony application framework"
end
