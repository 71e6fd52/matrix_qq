lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'matrix_qq/version'

Gem::Specification.new do |spec|
  spec.name          = 'matrix_qq'
  spec.version       = MatrixQQ::VERSION
  spec.authors       = ['71e6fd52']
  spec.email         = ['DAStudio.71e6fd52@gmail.com']

  spec.summary       = 'bridge between matrix and QQ'
  spec.homepage      = 'https://github.com/71e6fd52/matrix_qq'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake',    '~> 12.3'
  spec.add_development_dependency 'rspec',   '~> 3.7'

  spec.add_dependency 'ruby-dbus', '~> 0.14.0'
  spec.add_dependency 'matrix_dbus', '~> 1.0'
  spec.add_dependency 'CQHTTP', '~> 2.2'
  spec.add_dependency 'concurrent-ruby'
end
