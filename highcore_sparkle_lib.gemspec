$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'

Gem::Specification.new do |s|
  s.name               = "highcore_sparkle_lib"
  s.version            = "0.0.2"

  s.authors = ["Aleksandr Saraikin"]
  s.date = %q{2015-11-14}
  s.description = %q{Highcore library of sparkle formation registry and dynamics}
  s.email = %q{alex@sourcestream.de}
  s.files = Dir['{dynamics}/**/*'] + Dir['{registry}/**/*'] + %w(highcore_sparkle_lib.gemspec LICENSE.md README.md)
  s.homepage = %q{http://rubygems.org/gems/highcore_sparkle_lib}
  s.license = 'MIT'
  s.summary = %q{Highcore library for sparkle formation}

end

