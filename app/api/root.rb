module API
  require 'resources/users'

  class Root < Grape::API
    version 'v1', :using => :path, vendor: 'sample', cascade: false
    prefix 'api'
    format :json

    helpers do
      def require_oauth_token
        @current_token = request.env[Rack::OAuth2::Server::Resource::ACCESS_TOKEN]
        raise Rack::OAuth2::Server::Resource::Bearer::Unauthorized unless @current_token
      end
    end

    desc 'Gets the latest version.'
    get :version do
      {version: '1.0.0'}
    end

    mount Resources::Users

    add_swagger_documentation(
      api_version: 'v1',
      mount_path: 'doc',
      hide_documentation_path: true,
      markdown: true
      )
  end
end