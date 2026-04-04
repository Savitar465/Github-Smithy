# Especificación: Gestión de Archivos y Git - Mini-GitHub

## Resumen

Este documento describe las APIs y modelos necesarios para implementar la gestión de archivos y operaciones Git en Mini-GitHub, basándose en la API de Gitea y **alineado con las historias de usuario definidas**.

**Scope:** 17 operaciones (6 existentes + 10 nuevas + 1 mejorar)

---

## 1. Historias de Usuario Cubiertas

| HU | Título | Operaciones |
|----|--------|-------------|
| HU-09 | Fork de repositorio público | `ForkRepository`, `ListForks` |
| HU-13 | Navegación de archivos y carpetas | `GetFileContent` |
| HU-14 | Subir archivos desde la web | `CreateFile`, `UpdateFile` |
| HU-15 | Eliminar archivos desde la web | `DeleteFile` |
| HU-16 | Descargar archivos del repositorio | `GetRawFile`, `DownloadArchive` |
| HU-17 | Crear carpetas en el repositorio | `CreateFolder` |
| HU-18 | Ver historial de commits | `ListCommits`, `GetCommit`, `GetCommitDiff` |
| HU-19 | Gestión de branches | `ListBranches`, `GetBranch`, `CreateBranch`, `DeleteBranch` |
| HU-20 | Crear Pull Request | `CompareCommits` |

---

## 2. Requisitos Funcionales

| ID | Requerimiento |
|----|---------------|
| RF02.5 | El sistema debe gestionar branches de repositorios |
| RF02.6 | El sistema debe permitir hacer fork de repositorios públicos |
| RF03.1 | El sistema debe permitir subir archivos a un repositorio |
| RF03.2 | El sistema debe permitir descargar archivos de un repositorio |
| RF03.3 | El sistema debe mostrar el contenido de archivos de texto |
| RF03.4 | El sistema debe permitir crear carpetas |
| RF03.5 | El sistema debe permitir eliminar archivos |

---

## 3. APIs de Gitea - Referencia

### 3.1 Contenido de Archivos

#### GET - Obtener Contenido
```
GET /api/v1/repos/{owner}/{repo}/contents/{filepath}?ref={branch}
```

**Response:**
```json
{
  "name": "README.md",
  "path": "README.md",
  "sha": "abc123...",
  "type": "file",
  "size": 1234,
  "encoding": "base64",
  "content": "VGhpcyBpcyB0aGUgY29udGVudA==",
  "download_url": "...",
  "html_url": "...",
  "last_commit_sha": "def456..."
}
```

**Tipos:** `file`, `dir`

---

#### POST - Crear Archivo
```
POST /api/v1/repos/{owner}/{repo}/contents/{filepath}
```

**Request Body:**
```json
{
  "content": "VGhpcyBpcyB0aGUgY29udGVudA==",
  "message": "Add new file",
  "branch": "main",
  "author": { "name": "...", "email": "..." },
  "committer": { "name": "...", "email": "..." }
}
```

| Campo | Tipo | Requerido |
|-------|------|-----------|
| `content` | string (base64) | **Sí** |
| `message` | string | **Sí** |
| `branch` | string | No |
| `author` | Identity | No |
| `committer` | Identity | No |

---

#### PUT - Actualizar Archivo
```
PUT /api/v1/repos/{owner}/{repo}/contents/{filepath}
```

**Request Body:**
```json
{
  "sha": "abc123...",
  "content": "VXBkYXRlZCBjb250ZW50",
  "message": "Update file",
  "branch": "main"
}
```

| Campo | Tipo | Requerido |
|-------|------|-----------|
| `sha` | string | **Sí** (concurrencia) |
| `content` | string (base64) | **Sí** |
| `message` | string | **Sí** |

---

#### DELETE - Eliminar Archivo
```
DELETE /api/v1/repos/{owner}/{repo}/contents/{filepath}
```

**Request Body:**
```json
{
  "sha": "abc123...",
  "message": "Delete file",
  "branch": "main"
}
```

---

### 3.2 Raw y Archive

#### GET - Archivo Raw
```
GET /api/v1/repos/{owner}/{repo}/raw/{filepath}?ref={branch}
```

#### GET - Archive ZIP
```
GET /api/v1/repos/{owner}/{repo}/archive/{branch}.zip
```

---

### 3.3 Commits

#### GET - Listar Commits
```
GET /api/v1/repos/{owner}/{repo}/commits?sha={branch}&page={n}&limit={n}
```

#### GET - Obtener Commit
```
GET /api/v1/repos/{owner}/{repo}/git/commits/{sha}
```

#### GET - Diff de Commit
```
GET /api/v1/repos/{owner}/{repo}/git/commits/{sha}.diff
```

---

### 3.4 Comparar Branches

```
GET /api/v1/repos/{owner}/{repo}/compare/{base}...{head}
```

**Response:**
```json
{
  "commits": [...],
  "total_commits": 5,
  "files": [
    { "filename": "...", "status": "modified", "additions": 10, "deletions": 5 }
  ]
}
```

---

### 3.5 Branches

#### GET - Listar Branches
```
GET /api/v1/repos/{owner}/{repo}/branches
```

#### GET - Obtener Branch
```
GET /api/v1/repos/{owner}/{repo}/branches/{branch}
```

#### POST - Crear Branch
```
POST /api/v1/repos/{owner}/{repo}/branches
```

**Request Body:**
```json
{ "new_branch_name": "feature/new", "old_branch_name": "main" }
```

#### DELETE - Eliminar Branch
```
DELETE /api/v1/repos/{owner}/{repo}/branches/{branch}
```

---

### 3.6 Forks

#### GET - Listar Forks
```
GET /api/v1/repos/{owner}/{repo}/forks
```

#### POST - Crear Fork
```
POST /api/v1/repos/{owner}/{repo}/forks
```

**Request Body:**
```json
{ "name": "my-fork" }
```

---

## 4. Estado Actual vs Requerido

### 4.1 Operaciones en repo.smithy (Existentes)

| Operación | Estado | Acción |
|-----------|--------|--------|
| `GetRepoContents` | Parcial | Mejorar (agregar sha, content) |
| `UploadFile` | Existe | Reemplazar por CreateFile/UpdateFile |
| `DeleteFile` | Parcial | Mejorar (sha en body) |
| `DownloadArchive` | OK | Mantener |
| `ListBranches` | OK | Mantener |
| `CreateBranch` | OK | Mantener |
| `DeleteBranch` | OK | Mantener |

### 4.2 Operaciones Nuevas Requeridas

| Operación | Ubicación | HU |
|-----------|-----------|-----|
| `GetFileContent` | files.smithy | HU-13 |
| `CreateFile` | files.smithy | HU-14 |
| `UpdateFile` | files.smithy | HU-14 |
| `CreateFolder` | files.smithy | HU-17 |
| `GetRawFile` | files.smithy | HU-16 |
| `ListCommits` | files.smithy | HU-18 |
| `GetCommit` | files.smithy | HU-18 |
| `GetCommitDiff` | files.smithy | HU-18 |
| `CompareCommits` | files.smithy | HU-20 |
| `GetBranch` | repo.smithy | HU-19 |
| `ForkRepository` | repo.smithy | HU-09 |
| `ListForks` | repo.smithy | HU-09 |

---

## 5. Operaciones Finales por Archivo

### 5.1 files.smithy (NUEVO)

| Operación | Método | URI | HU |
|-----------|--------|-----|-----|
| `GetFileContent` | GET | `/v1/repos/{owner}/{repo}/contents/{filePath}` | HU-13 |
| `CreateFile` | POST | `/v1/repos/{owner}/{repo}/contents/{filePath}` | HU-14 |
| `UpdateFile` | PUT | `/v1/repos/{owner}/{repo}/contents/{filePath}` | HU-14 |
| `DeleteFile` | DELETE | `/v1/repos/{owner}/{repo}/contents/{filePath}` | HU-15 |
| `CreateFolder` | POST | `/v1/repos/{owner}/{repo}/folders` | HU-17 |
| `GetRawFile` | GET | `/v1/repos/{owner}/{repo}/raw/{filePath}` | HU-16 |
| `ListCommits` | GET | `/v1/repos/{owner}/{repo}/commits` | HU-18 |
| `GetCommit` | GET | `/v1/repos/{owner}/{repo}/commits/{sha}` | HU-18 |
| `GetCommitDiff` | GET | `/v1/repos/{owner}/{repo}/commits/{sha}/diff` | HU-18 |
| `CompareCommits` | GET | `/v1/repos/{owner}/{repo}/compare/{baseBranch}...{headBranch}` | HU-20 |

### 5.2 repo.smithy (AGREGAR)

| Operación | Método | URI | HU |
|-----------|--------|-----|-----|
| `GetBranch` | GET | `/v1/repos/{owner}/{repo}/branches/{branch}` | HU-19 |
| `ForkRepository` | POST | `/v1/repos/{owner}/{repo}/forks` | HU-09 |
| `ListForks` | GET | `/v1/repos/{owner}/{repo}/forks` | HU-09 |

### 5.3 repo.smithy (MANTENER)

| Operación | Método | URI |
|-----------|--------|-----|
| `DownloadArchive` | GET | `/v1/repos/{owner}/{repo}/archive` |
| `ListBranches` | GET | `/v1/repos/{owner}/{repo}/branches` |
| `CreateBranch` | POST | `/v1/repos/{owner}/{repo}/branches` |
| `DeleteBranch` | DELETE | `/v1/repos/{owner}/{repo}/branches/{branch}` |

### 5.4 repo.smithy (ELIMINAR)

| Operación | Razón |
|-----------|-------|
| `GetRepoContents` | Reemplazado por `GetFileContent` en files.smithy |
| `UploadFile` | Reemplazado por `CreateFile`/`UpdateFile` en files.smithy |

---

## 6. Estructuras de Datos

### 6.1 Tipos Comunes (common.smithy - agregar)

```smithy
// Identidad para autor/committer
structure Identity {
    @required
    name: String

    @required
    email: Email
}

// Tipo de contenido Git
enum GitObjectType {
    FILE      = "file"
    DIRECTORY = "dir"
}
```

### 6.2 Archivos (files.smithy)

```smithy
// Contenido de archivo (respuesta GET)
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

    encoding: String         // "base64" para archivos

    content: String          // Contenido en base64

    @required
    downloadUrl: Url

    htmlUrl: Url

    lastCommitSha: String
}

// Entrada de directorio
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

// Crear archivo (request)
structure CreateFileBody {
    @required
    content: String

    @required
    @length(min: 1, max: 500)
    message: String

    branch: String

    author: Identity

    committer: Identity
}

// Actualizar archivo (request)
structure UpdateFileBody {
    @required
    sha: String

    @required
    content: String

    @required
    @length(min: 1, max: 500)
    message: String

    branch: String

    fromPath: String

    author: Identity

    committer: Identity
}

// Eliminar archivo (request)
structure DeleteFileBody {
    @required
    sha: String

    @required
    @length(min: 1, max: 500)
    message: String

    branch: String

    author: Identity

    committer: Identity
}

// Crear carpeta (request)
structure CreateFolderBody {
    @required
    @length(min: 1, max: 255)
    @pattern("^[a-zA-Z0-9._/-]+$")
    name: String

    @required
    @length(min: 1, max: 500)
    message: String

    branch: String
}

// Respuesta de operación (create/update/delete)
structure FileOperationResponse {
    @required
    content: FileContentDTO

    @required
    commit: CommitSummaryDTO
}
```

### 6.3 Commits (files.smithy)

```smithy
// Commit completo
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

// Firma de commit
structure CommitSignature {
    @required
    name: String

    @required
    email: Email

    @required
    date: String
}

// Commit padre
structure CommitParent {
    @required
    sha: String

    url: Url
}

list CommitParentList {
    member: CommitParent
}

list CommitList {
    member: CommitDTO
}

// Resumen de commit
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

// Archivo cambiado
structure CommitFile {
    @required
    filename: String

    @required
    status: String

    additions: Integer

    deletions: Integer

    changes: Integer

    patch: String
}

list CommitFileList {
    member: CommitFile
}

// Comparación de branches (HU-20)
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
```

### 6.4 Branches (repo.smithy - agregar a BranchDTO)

```smithy
// Branch con detalle de commit
structure BranchDetailDTO {
    @required
    name: String

    @required
    isDefault: Boolean

    @required
    commit: CommitSummaryDTO

    protected: Boolean
}
```

### 6.5 Forks (repo.smithy - agregar)

```smithy
// Crear fork (request)
structure CreateForkBody {
    name: RepoName
}

// Fork info (response)
structure ForkInfoDTO {
    @required
    repository: RepositoryDTO

    @required
    parent: RepositorySummaryDTO
}

// Resumen de repositorio (para parent)
structure RepositorySummaryDTO {
    @required
    id: Uuid

    @required
    name: RepoName

    @required
    fullName: String

    @required
    ownerUsername: Username
}

list ForkList {
    member: ForkInfoDTO
}
```

---

## 7. Resumen de Cambios

| Archivo | Agregar | Modificar | Eliminar |
|---------|---------|-----------|----------|
| `common.smithy` | Identity, GitObjectType | - | - |
| `files.smithy` | **NUEVO** (10 ops) | - | - |
| `repo.smithy` | GetBranch, ForkRepository, ListForks, estructuras | - | GetRepoContents, UploadFile |
| `service.smithy` | 13 nuevas operaciones | - | 2 operaciones |

### Conteo Final

| Categoría | Cantidad |
|-----------|----------|
| Operaciones existentes (mantener) | 4 |
| Operaciones existentes (mejorar) | 1 |
| Operaciones nuevas | 12 |
| **TOTAL** | **17** |

---

## 8. Estructura de Archivos

```
model/
├── common/
│   └── common.smithy       # + Identity, GitObjectType
├── repo/
│   └── repo.smithy         # + GetBranch, Fork ops, - GetRepoContents, - UploadFile
├── files/
│   └── files.smithy        # NUEVO - Archivos + Commits
├── issue/
│   └── issue.smithy        # Sin cambios
├── search/
│   └── search.smithy       # Sin cambios
└── service.smithy          # + nuevas operaciones
```

---

## 9. Próximos Pasos

1. [ ] Agregar `Identity`, `GitObjectType` a `common.smithy`
2. [ ] Crear `model/files/files.smithy` con estructuras y operaciones
3. [ ] Agregar `GetBranch`, `ForkRepository`, `ListForks` a `repo.smithy`
4. [ ] Agregar estructuras de Fork a `repo.smithy`
5. [ ] Eliminar `GetRepoContents`, `UploadFile` de `repo.smithy`
6. [ ] Mejorar `DeleteFile` en `repo.smithy` (mover a files.smithy)
7. [ ] Actualizar `service.smithy` con nuevas operaciones
8. [ ] Ejecutar `./gradlew build` para validar
9. [ ] Generar OpenAPI con `./gradlew smithyBuild`

---

## Referencias

- [Gitea API Documentation v1.20](https://docs.gitea.com/api/1.20/)
- [Gitea Go SDK](https://pkg.go.dev/code.gitea.io/sdk/gitea)
- Historias de Usuario: `C:\Python\github-docs\docs\HistoriasDeUsuario.md`
- Requisitos Funcionales: `C:\Python\github-docs\docs\RFuncionales.md`

---

**Última actualización:** 2026-04-04
**Rama:** feat/file-management
**Operaciones totales:** 17
