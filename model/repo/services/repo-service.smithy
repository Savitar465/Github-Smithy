$version: "2"

namespace com.githubx.repo

use aws.protocols#restJson1
use aws.apigateway#integration

@title("GitHub Repo API")
@restJson1
@httpBearerAuth
@integration(
    type: "http_proxy"
    uri: "https://example.com/repo"
    httpMethod: "POST"
)
@documentation("Servicio de repositorios, ramas, forks y colaboradores.")
service RepoApi {
    version: "1.0.0"
    operations: [
        ListMyRepositories
        CreateRepository
        GetRepository
        UpdateRepository
        DeleteRepository
        ForkRepository
        ListRepositoryForks
        ListBranches
        GetBranch
        CreateBranch
        DeleteBranch
        ListCollaborators
        GetCollaborator
        AddCollaboratorByUsername
        AddCollaboratorWithRole
        UpdateCollaboratorRole
        RemoveCollaborator
    ]
}

