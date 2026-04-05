$version: "2"

namespace com.minigithub.search
use aws.protocols#restJson1
use com.minigithub.common#Uuid
use com.minigithub.common#Username
use com.minigithub.common#RepoName
use com.minigithub.common#Url
use com.minigithub.common#RepoVisibility
use com.minigithub.common#IssueState
use com.minigithub.common#PaginationMeta
use com.minigithub.common#BadRequestError
use com.minigithub.common#UnauthorizedError
use com.minigithub.common#InternalServerError

// ─── Resultado: repositorios ──────────────────────────────────

structure RepoSearchResult {
    @required
    id: Uuid

    @required
    name: RepoName

    @required
    fullName: String

    description: String

    @required
    visibility: RepoVisibility

    @required
    ownerUsername: Username

    @required
    starsCount: Integer

    language: String

    @required
    updatedAt: String

    @required
    score: Float
}

list RepoSearchResultList {
    member: RepoSearchResult
}

// ─── Resultado: usuarios ──────────────────────────────────────

structure UserSearchResult {
    @required
    id: Uuid

    @required
    username: Username

    bio: String

    avatarUrl: Url

    @required
    publicReposCount: Integer

    @required
    score: Float
}

list UserSearchResultList {
    member: UserSearchResult
}

// ─── Resultado: issues ────────────────────────────────────────

structure IssueSearchResult {
    @required
    id: Uuid

    @required
    repoFullName: String

    @required
    number: Integer

    @required
    title: String

    body: String

    @required
    state: IssueState

    @required
    authorUsername: Username

    @required
    createdAt: String

    @required
    score: Float
}

list IssueSearchResultList {
    member: IssueSearchResult
}

// ─── RF05.1: Buscar repositorios ──────────────────────────────

@http(method: "GET", uri: "/v1/search/repositories", code: 200)
@readonly
@documentation("Busca repositorios públicos por nombre, descripción o lenguaje. RF05.1")
operation SearchRepositories {
    input: SearchRepositoriesInput
    output: SearchRepositoriesOutput
    errors: [
        BadRequestError
        UnauthorizedError
        InternalServerError
    ]
}

structure SearchRepositoriesInput {
    @required
    @httpQuery("q")
    @length(min: 1, max: 255)
    q: String

    @httpQuery("language")
    language: String

    @httpQuery("sort")
    sort: SearchRepoSort

    @httpQuery("page")
    @range(min: 1)
    page: Integer

    @httpQuery("perPage")
    @range(min: 1, max: 50)
    perPage: Integer
}

enum SearchRepoSort {
    STARS     = "stars"
    UPDATED   = "updated"
    RELEVANCE = "relevance"
}

structure SearchRepositoriesOutput {
    @required
    @httpPayload
    body: SearchRepositoriesBody
}

structure SearchRepositoriesBody {
    @required
    totalCount: Integer

    @required
    results: RepoSearchResultList

    @required
    pagination: PaginationMeta
}

// ─── RF05.2: Buscar usuarios ──────────────────────────────────

@http(method: "GET", uri: "/v1/search/users", code: 200)
@readonly
@documentation("Busca usuarios por username. RF05.2")
operation SearchUsers {
    input: SearchUsersInput
    output: SearchUsersOutput
    errors: [
        BadRequestError
        UnauthorizedError
        InternalServerError
    ]
}

structure SearchUsersInput {
    @required
    @httpQuery("q")
    @length(min: 1, max: 100)
    q: String

    @httpQuery("page")
    @range(min: 1)
    page: Integer

    @httpQuery("perPage")
    @range(min: 1, max: 50)
    perPage: Integer
}

structure SearchUsersOutput {
    @required
    @httpPayload
    body: SearchUsersBody
}

structure SearchUsersBody {
    @required
    totalCount: Integer

    @required
    results: UserSearchResultList

    @required
    pagination: PaginationMeta
}

// ─── Buscar issues ────────────────────────────────────────────

@http(method: "GET", uri: "/v1/search/issues", code: 200)
@readonly
@documentation("Busca issues en repositorios accesibles por el usuario.")
operation SearchIssues {
    input: SearchIssuesInput
    output: SearchIssuesOutput
    errors: [
        BadRequestError
        UnauthorizedError
        InternalServerError
    ]
}

structure SearchIssuesInput {
    @required
    @httpQuery("q")
    @length(min: 1, max: 255)
    q: String

    @httpQuery("state")
    state: IssueState

    @httpQuery("repo")
    repo: String

    @httpQuery("page")
    @range(min: 1)
    page: Integer

    @httpQuery("perPage")
    @range(min: 1, max: 50)
    perPage: Integer
}

structure SearchIssuesOutput {
    @required
    @httpPayload
    body: SearchIssuesBody
}

structure SearchIssuesBody {
    @required
    totalCount: Integer

    @required
    results: IssueSearchResultList

    @required
    pagination: PaginationMeta
}

@title("Mini-GitHub Search API")
@restJson1
@httpBearerAuth
@documentation("Servicio de busqueda de repositorios, usuarios e issues.")
service SearchApi {
    version: "1.0.0"
    operations: [
        SearchRepositories
        SearchUsers
        SearchIssues
    ]
}

