require "github/graphql/client/version"
require "graphql/client"
require "graphql/client/http"

module GitHub
  module GraphQL
    URL = 'https://api.github.com/graphql'.freeze

    class Client
      def initialize(token: )
        http = ::GraphQL::Client::HTTP.new(GitHub::GraphQL::URL) do
          define_method :headers, ->(context) { context.merge({"Authorization" => "bearer #{token}"}) }
        end
        schema = ::GraphQL::Client.load_schema(http)

        @client = ::GraphQL::Client.new(schema: schema, execute: http)
        @client.allow_dynamic_queries = true
      end

      def query(query_string)
        query  = @client.parse(query_string)
        result = @client.query(query)
        result.data
      end
    end
  end
end
