$version: "2"

namespace com.minigithub.issue
use com.minigithub.common#Uuid
use com.minigithub.common#Username
use com.minigithub.common#RepoName
use com.minigithub.common#Title
use com.minigithub.common#HexColor
use com.minigithub.common#IssueState
use com.minigithub.common#PrStatus
use com.minigithub.common#PaginationMeta
use com.minigithub.common#BadRequestError
use com.minigithub.common#UnauthorizedError
use com.minigithub.common#ForbiddenError
use com.minigithub.common#NotFoundError
use com.minigithub.common#ConflictError
use com.minigithub.common#UnprocessableEntityError
use com.minigithub.common#InternalServerError

// ─── Tipos de soporte ─────────────────────────────────────────

structure AuthorSummary {
    @required
    id: Uuid

    @required
    username: Username
}

// ─── Labels ───────────────────────────────────────────────────

structure LabelDTO {
    @required
    id: Uuid

    @required
    repoId: String

    @required
    @length(min: 1, max: 50)
    name: String

    @required
    color: HexColor

    description: String
}

list LabelList {
    member: LabelDTO
}

list LabelNameList {
    member: String
}

// ─── Issues ───────────────────────────────────────────────────

structure IssueDTO {
    @required
    id: Uuid

    @required
    repoId: String

    @required
    number: Integer

    @required
    title: Title

    body: String

    @required
    state: IssueState

    @required
    author: AuthorSummary

    assignee: AuthorSummary

    @required
    labels: LabelList

    @required
    commentsCount: Integer

    @required
    createdAt: String

    @required
    updatedAt: String

    closedAt: String
}

list IssueList {
    member: IssueDTO
}

// ─── Listar issues ────────────────────────────────────────────

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/issues", code: 200)
@readonly
@documentation("Lista los issues de un repositorio con filtros opcionales. RF04")
operation ListIssues {
    input: ListIssuesInput
    output: ListIssuesOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure ListIssuesInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @httpQuery("state")
    state: IssueState

    @httpQuery("label")
    label: String

    @httpQuery("assignee")
    assignee: String

    @httpQuery("page")
    @range(min: 1)
    page: Integer

    @httpQuery("perPage")
    @range(min: 1, max: 100)
    perPage: Integer
}

structure ListIssuesOutput {
    @required
    @httpPayload
    body: ListIssuesBody
}

structure ListIssuesBody {
    @required
    issues: IssueList

    @required
    pagination: PaginationMeta
}

// ─── Crear issue ─────────────────────────────────────────────

@http(method: "POST", uri: "/v1/repos/{owner}/{repo}/issues", code: 201)
@documentation("Crea un issue en el repositorio. RF04.1")
operation CreateIssue {
    input: CreateIssueInput
    output: CreateIssueOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure CreateIssueInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpPayload
    body: CreateIssueBody
}

structure CreateIssueBody {
    @required
    title: Title

    body: String

    labels: LabelNameList

    assignee: String
}

structure CreateIssueOutput {
    @required
    @httpPayload
    body: IssueDTO
}

// ─── Obtener issue ────────────────────────────────────────────

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/issues/{issueNumber}", code: 200)
@readonly
@documentation("Obtiene un issue por su número secuencial. RF04")
operation GetIssue {
    input: GetIssueInput
    output: GetIssueOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure GetIssueInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    issueNumber: String
}

structure GetIssueOutput {
    @required
    @httpPayload
    body: IssueDTO
}

// ─── Actualizar issue ─────────────────────────────────────────

@http(method: "PATCH", uri: "/v1/repos/{owner}/{repo}/issues/{issueNumber}", code: 200)
@documentation("Actualiza título, body, estado, assignee o labels. RF04.4, RF04.5")
operation UpdateIssue {
    input: UpdateIssueInput
    output: UpdateIssueOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure UpdateIssueInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    issueNumber: String

    @required
    @httpPayload
    body: UpdateIssueBody
}

structure UpdateIssueBody {
    title: Title
    body: String
    state: IssueState
    assignee: String
    labels: LabelNameList
}

structure UpdateIssueOutput {
    @required
    @httpPayload
    body: IssueDTO
}

// ─── Comentarios ──────────────────────────────────────────────

structure CommentDTO {
    @required
    id: Uuid

    @required
    issueId: Uuid

    @required
    @length(min: 1)
    body: String

    @required
    author: AuthorSummary

    @required
    createdAt: String

    @required
    updatedAt: String
}

list CommentList {
    member: CommentDTO
}

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/issues/{issueNumber}/comments", code: 200)
@readonly
@documentation("Lista los comentarios de un issue. RF04.3")
operation ListIssueComments {
    input: IssueCommentsInput
    output: ListIssueCommentsOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure IssueCommentsInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    issueNumber: String
}

structure ListIssueCommentsOutput {
    @required
    @httpPayload
    body: ListIssueCommentsBody
}

structure ListIssueCommentsBody {
    @required
    comments: CommentList
}

@http(method: "POST", uri: "/v1/repos/{owner}/{repo}/issues/{issueNumber}/comments", code: 201)
@documentation("Agrega un comentario a un issue. RF04.3")
operation CreateIssueComment {
    input: CreateIssueCommentInput
    output: CreateIssueCommentOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure CreateIssueCommentInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    issueNumber: String

    @required
    @httpPayload
    body: CreateIssueCommentBody
}

structure CreateIssueCommentBody {
    @required
    @length(min: 1)
    body: String
}

structure CreateIssueCommentOutput {
    @required
    @httpPayload
    body: CommentDTO
}

// ─── Labels de repositorio ────────────────────────────────────

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/labels", code: 200)
@readonly
@documentation("Lista los labels disponibles en el repositorio. RF04.2")
operation ListLabels {
    input: RepoOnlyInput
    output: ListLabelsOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure RepoOnlyInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName
}

structure ListLabelsOutput {
    @required
    @httpPayload
    body: ListLabelsBody
}

structure ListLabelsBody {
    @required
    labels: LabelList
}

@http(method: "POST", uri: "/v1/repos/{owner}/{repo}/labels", code: 201)
@documentation("Crea un label nuevo en el repositorio. RF04.2")
operation CreateLabel {
    input: CreateLabelInput
    output: CreateLabelOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        ConflictError
        InternalServerError
    ]
}

structure CreateLabelInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpPayload
    body: CreateLabelBody
}

structure CreateLabelBody {
    @required
    @length(min: 1, max: 50)
    name: String

    @required
    color: HexColor

    @length(max: 255)
    description: String
}

structure CreateLabelOutput {
    @required
    @httpPayload
    body: LabelDTO
}

// ─── Pull Requests ────────────────────────────────────────────

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

list PrList {
    member: PullRequestDTO
}

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/pulls", code: 200)
@readonly
@documentation("Lista los Pull Requests del repositorio. HU-19")
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
    pullRequests: PrList
}

@http(method: "POST", uri: "/v1/repos/{owner}/{repo}/pulls", code: 201)
@documentation("Crea un Pull Request entre dos ramas. HU-19, RF04.1")
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
@documentation("Obtiene el detalle de un PR. HU-20")
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
    prNumber: String
}

structure GetPullRequestOutput {
    @required
    @httpPayload
    body: PullRequestDTO
}

enum ReviewDecision {
    APPROVED          = "approved"
    CHANGES_REQUESTED = "changes_requested"
    COMMENTED         = "commented"
}

@http(method: "PATCH", uri: "/v1/repos/{owner}/{repo}/pulls/{prNumber}/review", code: 200)
@documentation("Aprueba o solicita cambios en un PR. HU-20, RF04.2")
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
    prNumber: String

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
    MERGE  = "merge"
    SQUASH = "squash"
    REBASE = "rebase"
}

@http(method: "POST", uri: "/v1/repos/{owner}/{repo}/pulls/{prNumber}/merge", code: 200)
@documentation("Ejecuta el merge de un PR aprobado. HU-21, RF04.3")
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
    prNumber: String

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
