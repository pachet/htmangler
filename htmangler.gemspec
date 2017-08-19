Gem::Specification.new do |spec|
  spec.name = 'htmangler'
  spec.version = '0.0.1'
  spec.date = '2017-08-20'
  spec.summary = 'Use Markov chains to generate probabilistic HTML pages'
  spec.files = Dir.glob("{bin,lib}/**/*") + 'LICENSE README.md'
  spec.require_path = 'lib'
  spec.license = 'ISC'
end
