# frozen_string_literal: true

module Grille
  class Engine < ::Rails::Engine
    # Configures Webpacker within the host app
    engine_name 'grille'
    isolate_namespace Grille

    # inject routes into host app
    initializer 'grille.configuration' do |app|
      app.routes.append do
        mount Grille::Engine => '/'
      end
    end

    initializer 'webpacker.proxy' do |app|
      insert_middleware = begin
                          Grille.webpacker.config.dev_server.present?
                          rescue StandardError
                            nil
                        end
      next unless insert_middleware

      app.middleware.insert_before(
        0, Webpacker::DevServerProxy, # "Webpacker::DevServerProxy" if Rails version < 5
        ssl_verify_none: true,
        webpacker: Grille.webpacker
      )
    end

    # Serves the engine's webpack when requested
    initializer 'webpacker.static' do |app|
      app.config.middleware.use(
        Rack::Static,
        urls: ['/grille-packs'],
        root: File.expand_path(File.join(__dir__, '..', '..', 'public'))
      )
    end
  end
end
