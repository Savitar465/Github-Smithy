$version: "2"

namespace com.githubx.pullrequest

use aws.protocols#restJson1
use com.githubx.common#BadRequestError
use com.githubx.common#ConflictError
use com.githubx.common#ForbiddenError
use com.githubx.common#InternalServerError
use com.githubx.common#NotFoundError
use com.githubx.common#PrStatus
use com.githubx.common#RepoName
use com.githubx.common#Title
use com.githubx.common#UnauthorizedError
use com.githubx.common#UnprocessableEntityError
use com.githubx.common#Username
use com.githubx.common#Uuid

structure AuthorSummary {
    @required
    id: Uuid

    @required
    username: Username
}

structure PullRequestDTO {
    @required
    id: Uuid

    @required
    repoId: String

    @required
    number: Integer

    @required
    title: Title

    description: String

    @required
    sourceBranch: String

    @required
    targetBranch: String

    @required
    author: AuthorSummary

    @required
    status: PrStatus

    @required
    hasConflicts: Boolean

    @required
    commitsCount: Integer

    @required
    createdAt: String

    @required
    updatedAt: String

    mergedAt: String
}

list PullRequestList {
    member: PullRequestDTO
}

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/pulls", code: 200)
@readonly
@documentation("Lista los pull requests del repositorio. RF07")
operation ListPullRequests {
    input: ListPullRequestsInput
    output: ListPullRequestsOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure ListPullRequestsInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @httpQuery("status")
    status: PrStatus
}

structure ListPullRequestsOutput {
    @required
    @httpPayload
    body: ListPullRequestsBody
}

structure ListPullRequestsBody {
    @required
    pullRequests: PullRequestList
}

@http(method: "POST", uri: "/v1/repos/{owner}/{repo}/pulls", code: 201)
@documentation("Crea un pull request entre dos ramas. RF07.1")
operation CreatePullRequest {
    input: CreatePullRequestInput
    output: CreatePullRequestOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        ConflictError
        InternalServerError
    ]
}

structure CreatePullRequestInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpPayload
    body: CreatePullRequestBody
}

structure CreatePullRequestBody {
    @required
    title: Title

    description: String

    @required
    sourceBranch: String

    @required
    targetBranch: String
}

structure CreatePullRequestOutput {
    @required
    @httpPayload
    body: PullRequestDTO
}

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/pulls/{prNumber}", code: 200)
@readonly
@documentation("Obtiene el detalle de un pull request.")
operation GetPullRequest {
    input: GetPullRequestInput
    output: GetPullRequestOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure GetPullRequestInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    prNumber: Integer
}

structure GetPullRequestOutput {
    @required
    @httpPayload
    body: PullRequestDTO
}

enum ReviewDecision {
    APPROVED = "approved"
    CHANGES_REQUESTED = "changes_requested"
    COMMENTED = "commented"
}

@http(method: "PATCH", uri: "/v1/repos/{owner}/{repo}/pulls/{prNumber}/review", code: 200)
@documentation("Aprueba o solicita cambios en un pull request. RF07.2")
operation ReviewPullRequest {
    input: ReviewPullRequestInput
    output: ReviewPullRequestOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure ReviewPullRequestInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    prNumber: Integer

    @required
    @httpPayload
    body: ReviewPullRequestBody
}

structure ReviewPullRequestBody {
    @required
    decision: ReviewDecision

    comment: String
}

structure ReviewPullRequestOutput {
    @required
    @httpPayload
    body: PullRequestDTO
}

enum MergeStrategy {
    MERGE = "merge"
    SQUASH = "squash"
    REBASE = "rebase"
}

@http(method: "POST", uri: "/v1/repos/{owner}/{repo}/pulls/{prNumber}/merge", code: 200)
@documentation("Ejecuta merge de un pull request aprobado y sin conflictos.")
operation MergePullRequest {
    input: MergePullRequestInput
    output: MergePullRequestOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        ConflictError
        UnprocessableEntityError
        InternalServerError
    ]
}

structure MergePullRequestInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    prNumber: Integer

    @required
    @httpPayload
    body: MergePullRequestBody
}

structure MergePullRequestBody {
    @required
    strategy: MergeStrategy

    @length(max: 500)
    commitMessage: String
}

structure MergePullRequestOutput {
    @required
    @httpPayload
    body: PullRequestDTO
}

structure PullRequestCommentDTO {
    @required
    id: Uuid

    @required
    pullRequestId: Uuid

    @required
    body: String

    filePath: String

    @range(min: 1)
    lineNumber: Integer

    @required
    author: AuthorSummary

    @required
    createdAt: String

    @required
    updatedAt: String
}

list PullRequestCommentList {
    member: PullRequestCommentDTO
}

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/pulls/{prNumber}/comments", code: 200)
@readonly
@documentation("Lista comentarios de un pull request.")
operation ListPullRequestComments {
    input: PullRequestCommentsInput
    output: ListPullRequestCommentsOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

@http(method: "POST", uri: "/v1/repos/{owner}/{repo}/pulls/{prNumber}/comments", code: 201)
@documentation("Agrega un comentario general o por linea a un pull request.")
operation CreatePullRequestComment {
    input: CreatePullRequestCommentInput
    output: CreatePullRequestCommentOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure PullRequestCommentsInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    prNumber: Integer
}

structure ListPullRequestCommentsOutput {
    @required
    @httpPayload
    body: ListPullRequestCommentsBody
}

structure ListPullRequestCommentsBody {
    @required
    comments: PullRequestCommentList
}

structure CreatePullRequestCommentInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    prNumber: Integer

    @required
    @httpPayload
    body: CreatePullRequestCommentBody
}

structure CreatePullRequestCommentBody {
    @required
    @length(min: 1)
    body: String

    filePath: String

    @range(min: 1)
    lineNumber: Integer
}

structure CreatePullRequestCommentOutput {
    @required
    @httpPayload
    body: PullRequestCommentDTO
}

structure PullRequestMergeabilityDTO {
    @required
    prNumber: Integer

    @required
    mergeable: Boolean

    @required
    hasConflicts: Boolean

    reason: String
}

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/pulls/{prNumber}/mergeability", code: 200)
@readonly
@documentation("Evalua conflictos y mergeabilidad antes de merge. RF07.3")
operation GetPullRequestMergeability {
    input: GetPullRequestInput
    output: GetPullRequestMergeabilityOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure GetPullRequestMergeabilityOutput {
    @required
    @httpPayload
    body: PullRequestMergeabilityDTO
}

