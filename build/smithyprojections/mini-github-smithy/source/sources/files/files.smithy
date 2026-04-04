$version: "2"

namespace com.minigithub.files

use com.minigithub.common#Uuid
use com.minigithub.common#Username
use com.minigithub.common#Email
use com.minigithub.common#RepoName
use com.minigithub.common#Url
use com.minigithub.common#GitObjectType
use com.minigithub.common#Identity
use com.minigithub.common#PaginationMeta
use com.minigithub.common#BadRequestError
use com.minigithub.common#UnauthorizedError
use com.minigithub.common#ForbiddenError
use com.minigithub.common#NotFoundError
use com.minigithub.common#ConflictError
use com.minigithub.common#InternalServerError

// ═══════════════════════════════════════════════════════════════
// ESTRUCTURAS DE ARCHIVOS
// ═══════════════════════════════════════════════════════════════

/// Contenido de archivo (respuesta GET para archivos)
structure FileContentDTO {
    @required
    name: String

    @required
    path: String

    @required
    sha: String

    @required
    type: GitObjectType

    size: Long

    /// "base64" para archivos con contenido
    encoding: String

    /// Contenido del archivo en base64
    content: String

    @required
    downloadUrl: Url

    htmlUrl: Url

    /// SHA del último commit que modificó el archivo
    lastCommitSha: String
}

/// Entrada de directorio (para listar contenido de carpetas)
structure DirectoryEntryDTO {
    @required
    name: String

    @required
    path: String

    @required
    sha: String

    @required
    type: GitObjectType

    size: Long

    downloadUrl: Url
}

list DirectoryEntryList {
    member: DirectoryEntryDTO
}

/// Respuesta de operación de archivo (create/update/delete)
structure FileOperationResponse {
    @required
    content: FileContentDTO

    @required
    commit: CommitSummaryDTO
}

// ═══════════════════════════════════════════════════════════════
// ESTRUCTURAS DE COMMITS
// ═══════════════════════════════════════════════════════════════

/// Firma de commit (autor o committer)
structure CommitSignature {
    @required
    name: String

    @required
    email: Email

    @required
    date: String
}

/// Commit padre
structure CommitParent {
    @required
    sha: String

    url: Url
}

list CommitParentList {
    member: CommitParent
}

/// Commit completo
structure CommitDTO {
    @required
    sha: String

    @required
    message: String

    @required
    author: CommitSignature

    @required
    committer: CommitSignature

    htmlUrl: Url

    parents: CommitParentList
}

list CommitList {
    member: CommitDTO
}

/// Resumen de commit (para responses de operaciones)
structure CommitSummaryDTO {
    @required
    sha: String

    @required
    message: String

    @required
    author: CommitSignature

    @required
    committer: CommitSignature

    htmlUrl: Url
}

/// Archivo cambiado en un commit o comparación
structure CommitFile {
    @required
    filename: String

    /// added, modified, deleted, renamed
    @required
    status: String

    additions: Integer

    deletions: Integer

    changes: Integer

    /// Diff del archivo
    patch: String
}

list CommitFileList {
    member: CommitFile
}

/// Comparación entre branches (HU-20)
structure CompareDTO {
    @required
    commits: CommitList

    @required
    totalCommits: Integer

    @required
    files: CommitFileList

    @required
    aheadBy: Integer

    @required
    behindBy: Integer
}

// ═══════════════════════════════════════════════════════════════
// HU-13: NAVEGACIÓN DE ARCHIVOS Y CARPETAS
// ═══════════════════════════════════════════════════════════════

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/contents/{filePath}", code: 200)
@readonly
@documentation("Obtiene el contenido de un archivo o lista el contenido de un directorio. RF03.3")
operation GetFileContent {
    input: GetFileContentInput
    output: GetFileContentOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure GetFileContentInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    filePath: String

    /// Branch, tag o commit SHA
    @httpQuery("ref")
    ref: String
}

structure GetFileContentOutput {
    @required
    @httpPayload
    body: GetFileContentBody
}

/// Respuesta polimórfica: archivo o lista de entradas
structure GetFileContentBody {
    /// Si es archivo, contiene los datos del archivo
    file: FileContentDTO

    /// Si es directorio, contiene la lista de entradas
    entries: DirectoryEntryList
}

// ═══════════════════════════════════════════════════════════════
// HU-14: SUBIR ARCHIVOS DESDE LA WEB
// ═══════════════════════════════════════════════════════════════

@http(method: "POST", uri: "/v1/repos/{owner}/{repo}/contents/{filePath}", code: 201)
@documentation("Crea un archivo nuevo en el repositorio. RF03.1")
operation CreateFile {
    input: CreateFileInput
    output: CreateFileOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        ConflictError
        InternalServerError
    ]
}

structure CreateFileInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    filePath: String

    @required
    @httpPayload
    body: CreateFileBody
}

structure CreateFileBody {
    /// Contenido del archivo en base64
    @required
    content: String

    /// Mensaje del commit
    @required
    @length(min: 1, max: 500)
    message: String

    /// Branch destino (default: rama por defecto)
    branch: String

    /// Autor del commit
    author: Identity

    /// Committer del commit
    committer: Identity
}

structure CreateFileOutput {
    @required
    @httpPayload
    body: FileOperationResponse
}

// ─────────────────────────────────────────────────────────────────

@http(method: "PUT", uri: "/v1/repos/{owner}/{repo}/contents/{filePath}", code: 200)
@idempotent
@documentation("Actualiza un archivo existente en el repositorio. RF03.1")
operation UpdateFile {
    input: UpdateFileInput
    output: UpdateFileOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        ConflictError
        InternalServerError
    ]
}

structure UpdateFileInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    filePath: String

    @required
    @httpPayload
    body: UpdateFileBody
}

structure UpdateFileBody {
    /// SHA actual del archivo (para control de concurrencia)
    @required
    sha: String

    /// Nuevo contenido en base64
    @required
    content: String

    /// Mensaje del commit
    @required
    @length(min: 1, max: 500)
    message: String

    /// Branch destino
    branch: String

    /// Path original si es rename/move
    fromPath: String

    author: Identity

    committer: Identity
}

structure UpdateFileOutput {
    @required
    @httpPayload
    body: FileOperationResponse
}

// ═══════════════════════════════════════════════════════════════
// HU-15: ELIMINAR ARCHIVOS DESDE LA WEB
// ═══════════════════════════════════════════════════════════════

@http(method: "DELETE", uri: "/v1/repos/{owner}/{repo}/contents/{filePath}", code: 200)
@idempotent
@documentation("Elimina un archivo generando un commit de borrado. RF03.5")
operation DeleteFile {
    input: DeleteFileInput
    output: DeleteFileOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure DeleteFileInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    filePath: String

    /// SHA del archivo a eliminar (para control de concurrencia)
    @required
    @httpQuery("sha")
    sha: String

    /// Mensaje del commit
    @required
    @httpQuery("message")
    @length(min: 1, max: 500)
    message: String

    /// Branch donde eliminar
    @httpQuery("branch")
    branch: String
}

structure DeleteFileOutput {
    @required
    @httpPayload
    body: DeleteFileResponseBody
}

structure DeleteFileResponseBody {
    @required
    commit: CommitSummaryDTO
}

// ═══════════════════════════════════════════════════════════════
// HU-17: CREAR CARPETAS EN EL REPOSITORIO
// ═══════════════════════════════════════════════════════════════

@http(method: "POST", uri: "/v1/repos/{owner}/{repo}/folders", code: 201)
@documentation("Crea una carpeta nueva con .gitkeep. RF03.4")
operation CreateFolder {
    input: CreateFolderInput
    output: CreateFolderOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        ConflictError
        InternalServerError
    ]
}

structure CreateFolderInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpPayload
    body: CreateFolderBody
}

structure CreateFolderBody {
    /// Nombre/ruta de la carpeta
    @required
    @length(min: 1, max: 255)
    @pattern("^[a-zA-Z0-9._/-]+$")
    path: String

    /// Mensaje del commit
    @required
    @length(min: 1, max: 500)
    message: String

    /// Branch destino
    branch: String
}

structure CreateFolderOutput {
    @required
    @httpPayload
    body: FileOperationResponse
}

// ═══════════════════════════════════════════════════════════════
// HU-16: DESCARGAR ARCHIVOS DEL REPOSITORIO
// ═══════════════════════════════════════════════════════════════

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/raw/{filePath}", code: 200)
@readonly
@documentation("Descarga el contenido raw de un archivo. RF03.2")
operation GetRawFile {
    input: GetRawFileInput
    output: GetRawFileOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure GetRawFileInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    filePath: String

    /// Branch, tag o commit SHA
    @httpQuery("ref")
    ref: String
}

structure GetRawFileOutput {
    @required
    @httpHeader("Content-Type")
    contentType: String

    @required
    @httpHeader("Content-Disposition")
    contentDisposition: String
}

// ═══════════════════════════════════════════════════════════════
// HU-18: VER HISTORIAL DE COMMITS
// ═══════════════════════════════════════════════════════════════

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/commits", code: 200)
@readonly
@documentation("Lista el historial de commits del repositorio. HU-18")
operation ListCommits {
    input: ListCommitsInput
    output: ListCommitsOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure ListCommitsInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    /// Branch o SHA desde donde empezar
    @httpQuery("sha")
    sha: String

    /// Filtrar por path de archivo
    @httpQuery("path")
    path: String

    @httpQuery("page")
    @range(min: 1)
    page: Integer

    @httpQuery("perPage")
    @range(min: 1, max: 100)
    perPage: Integer
}

structure ListCommitsOutput {
    @required
    @httpPayload
    body: ListCommitsBody
}

structure ListCommitsBody {
    @required
    commits: CommitList

    @required
    pagination: PaginationMeta
}

// ─────────────────────────────────────────────────────────────────

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/commits/{sha}", code: 200)
@readonly
@documentation("Obtiene el detalle de un commit específico. HU-18")
operation GetCommit {
    input: GetCommitInput
    output: GetCommitOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure GetCommitInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    sha: String
}

structure GetCommitOutput {
    @required
    @httpPayload
    body: GetCommitBody
}

structure GetCommitBody {
    @required
    commit: CommitDTO

    /// Archivos modificados en este commit
    files: CommitFileList
}

// ─────────────────────────────────────────────────────────────────

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/commits/{sha}/diff", code: 200)
@readonly
@documentation("Obtiene el diff de un commit en formato texto. HU-18")
operation GetCommitDiff {
    input: GetCommitDiffInput
    output: GetCommitDiffOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure GetCommitDiffInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    @required
    @httpLabel
    sha: String
}

structure GetCommitDiffOutput {
    @required
    @httpHeader("Content-Type")
    contentType: String

    @required
    @httpPayload
    body: String
}

// ═══════════════════════════════════════════════════════════════
// HU-20: COMPARAR BRANCHES (para Pull Requests)
// ═══════════════════════════════════════════════════════════════

@http(method: "GET", uri: "/v1/repos/{owner}/{repo}/compare/{baseBranch}/{headBranch}", code: 200)
@readonly
@documentation("Compara dos branches mostrando commits y archivos cambiados. HU-20")
operation CompareCommits {
    input: CompareCommitsInput
    output: CompareCommitsOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure CompareCommitsInput {
    @required
    @httpLabel
    owner: Username

    @required
    @httpLabel
    repo: RepoName

    /// Branch base para comparación
    @required
    @httpLabel
    baseBranch: String

    /// Branch head para comparación
    @required
    @httpLabel
    headBranch: String
}

structure CompareCommitsOutput {
    @required
    @httpPayload
    body: CompareDTO
}
