$version: "2"

namespace com.githubx.search

use aws.protocols#restJson1
use aws.apigateway#integration

@title("GitHub Search API")
@restJson1
@httpBearerAuth
@integration(
    type: "http_proxy"
    uri: "https://example.com/search"
    httpMethod: "POST"
)
@documentation("Servicio de busqueda de repositorios, usuarios e issues.")
service SearchApi {
    version: "1.0.0"
    operations: [
        SearchRepositories
        SearchUsers
        SearchIssues
    ]
}

