# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'grille/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  def add_dependencies(spec, dependencies)
    dependencies.each do |d|
      spec.add_dependency(*(d.is_a?(String) ? [d] : d))
    end
  end

  spec.name        = 'grille'
  spec.version     = Grille::VERSION
  spec.authors     = ['Hayden McFarland']
  spec.email       = ['mcfarlandsms@gmail.com']
  spec.homepage    = 'http://haydenmcfarland.me'
  spec.summary     = 'Generalized VueJS Data Grid using GraphQL'
  spec.description = 'Generalized VueJS Data Grid using GraphQL'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)

  puts spec.files
  add_dependencies(
    spec,
    [
      'bcrypt',
      'bootsnap',
      'devise',
      'devise-jwt',
      'graphql',
      'jbuilder',
      'jwt_sessions',
      'pg',
      'puma',
      'rack-cors',
      ['rails', '~> 6.0.2', '>= 6.0.2.1'],
      'redis',
      'webpacker'
    ]
  )

  add_dependencies(
    spec,
    %w[
      graphiql-rails
      listen
      rubocop
      spring
      spring-watcher-listen
      web-console
    ]
  )
end
