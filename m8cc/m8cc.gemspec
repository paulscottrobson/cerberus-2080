Gem::Specification.new do |s|
  s.name        = 'm8cc'
  s.version     = '1.0.0'
  s.summary     = "m8cc"
  s.description = "A threaded programming language"
  s.authors     = ["Paul Robson"]
  s.email       = 'paul@robsons.org.uk'
  s.files       = ["lib/m8cc.rb","lib/runtime.rb","bin/m8cc"]
  s.homepage    = 'https://www.robsons.org.uk'
  s.license     = 'MIT'
  s.executables << "m8cc"
end