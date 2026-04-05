# Especificación: Gestión de Archivos y Git - Mini-GitHub

## Resumen

Este documento describe las APIs y modelos implementados para la gestión de archivos y operaciones Git en Mini-GitHub, basándose en la API de Gitea y **alineado con las historias de usuario definidas**.

**Scope:** 11 operaciones en FilesApi + 7 operaciones relacionadas en RepoApi

---

## 1. Historias de Usuario Cubiertas

| HU | Título | Operaciones |
|----|--------|-------------|
| HU-09 | Fork de repositorio público | `ForkRepository`, `ListRepositoryForks` |
| HU-13 | Navegación de archivos y carpetas | `GetFileContent`, `GetRepositoryContents` |
| HU-14 | Subir archivos desde la web | `CreateFile`, `UpdateFile` |
| HU-15 | Eliminar archivos desde la web | `DeleteFile` |
| HU-16 | Descargar archivos del repositorio | `GetRawFile`, `DownloadArchive` |
| HU-17 | Crear carpetas en el repositorio | `CreateFolder` |
| HU-18 | Ver historial de commits | `ListCommits`, `GetCommit`, `GetCommitDiff` |
| HU-19 | Gestión de branches | `ListBranches`, `GetBranch`, `CreateBranch`, `DeleteBranch` |
| HU-20 | Crear Pull Request | `CompareCommits` |

---

## 2. Requisitos Funcionales

| ID | Requerimiento | Operaciones |
|----|---------------|-------------|
| RF02.5 | El sistema debe gestionar branches de repositorios | `ListBranches`, `GetBranch`, `CreateBranch`, `DeleteBranch` |
| RF02.6 | El sistema debe permitir hacer fork de repositorios públicos | `ForkRepository`, `ListRepositoryForks` |
| RF03.1 | El sistema debe permitir subir archivos a un repositorio | `CreateFile`, `UpdateFile` |
| RF03.2 | El sistema debe permitir descargar archivos de un repositorio | `GetRawFile`, `DownloadArchive` |
| RF03.3 | El sistema debe mostrar el contenido de archivos de texto | `GetFileContent`, `GetRepositoryContents` |
| RF03.4 | El sistema debe permitir crear carpetas | `CreateFolder` |
| RF03.5 | El sistema debe permitir eliminar archivos | `DeleteFile` |

---

## 3. Operaciones Implementadas

### 3.1 FilesApi (files.smithy) - 11 operaciones

| Operación | Método | URI | HU | Descripción |
|-----------|--------|-----|-----|-------------|
| `GetFileContent` | GET | `/v1/repos/{owner}/{repo}/contents/{filePath+}` | HU-13 | Obtiene contenido de archivo o lista directorio |
| `GetRepositoryContents` | GET | `/v1/repos/{owner}/{repo}/contents?path=` | HU-13 | Lista contenido usando query param |
| `CreateFile` | PUT | `/v1/repos/{owner}/{repo}/contents/{filePath+}` | HU-14 | Crea archivo nuevo (idempotente) |
| `UpdateFile` | PATCH | `/v1/repos/{owner}/{repo}/contents/{filePath+}` | HU-14 | Actualiza archivo existente |
| `DeleteFile` | DELETE | `/v1/repos/{owner}/{repo}/contents/{filePath+}` | HU-15 | Elimina archivo con commit |
| `CreateFolder` | POST | `/v1/repos/{owner}/{repo}/folders` | HU-17 | Crea carpeta con .gitkeep |
| `GetRawFile` | GET | `/v1/repos/{owner}/{repo}/download?path=` | HU-16 | Descarga archivo raw |
| `ListCommits` | GET | `/v1/repos/{owner}/{repo}/commits` | HU-18 | Lista historial de commits |
| `GetCommit` | GET | `/v1/repos/{owner}/{repo}/commits/{sha}` | HU-18 | Obtiene detalle de commit |
| `GetCommitDiff` | GET | `/v1/repos/{owner}/{repo}/commits/{sha}/diff` | HU-18 | Obtiene diff en texto |
| `CompareCommits` | GET | `/v1/repos/{owner}/{repo}/compare/{baseBranch}/{headBranch}` | HU-20 | Compara dos branches |

### 3.2 RepoApi - Operaciones relacionadas (repo.smithy)

| Operación | Método | URI | HU |
|-----------|--------|-----|-----|
| `GetBranch` | GET | `/v1/repos/{owner}/{repo}/branches/{branch}` | HU-19 |
| `ForkRepository` | POST | `/v1/repos/{owner}/{repo}/forks` | HU-09 |
| `ListRepositoryForks` | GET | `/v1/repos/{owner}/{repo}/forks` | HU-09 |
| `DownloadArchive` | GET | `/v1/repos/{owner}/{repo}/archive` | HU-16 |
| `ListBranches` | GET | `/v1/repos/{owner}/{repo}/branches` | HU-19 |
| `CreateBranch` | POST | `/v1/repos/{owner}/{repo}/branches` | HU-19 |
| `DeleteBranch` | DELETE | `/v1/repos/{owner}/{repo}/branches/{branch}` | HU-19 |

---

## 4. Estructuras de Datos

### 4.1 Tipos Comunes (common.smithy)

```smithy
/// Identidad para autor/committer de commits
structure Identity {
    @required
    name: String

    @required
    email: Email
}

/// Tipo de objeto Git (archivo o directorio)
enum GitObjectType {
    FILE      = "file"
    DIRECTORY = "dir"
}

/// Mixin para operaciones con scope de repositorio
@mixin
structure RepoScopedInputMixin {
    @required
    owner: Username

    @required
    repo: RepoName
}
```

### 4.2 Archivos (files.smithy)

```smithy
/// Contenido binario de archivo (máximo 10MB)
@length(max: 10485760)
blob FileBytes

/// Contenido de archivo (respuesta GET)
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

/// Entrada de directorio
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

/// Respuesta de operación de archivo (create/update)
structure FileOperationResponse {
    @required
    content: FileContentDTO

    @required
    commit: CommitSummaryDTO
}

/// Crear archivo (request body)
structure CreateFileBody {
    @required
    content: FileBytes

    @required
    @length(min: 1, max: 500)
    message: String

    branch: String

    author: Identity

    committer: Identity
}

/// Actualizar archivo (request body)
structure UpdateFileBody {
    @required
    sha: String              // Control de concurrencia

    @required
    content: FileBytes

    @required
    @length(min: 1, max: 500)
    message: String

    branch: String

    fromPath: String         // Para rename/move

    author: Identity

    committer: Identity
}

/// Crear carpeta (request body)
structure CreateFolderBody {
    @required
    @length(min: 1, max: 255)
    @pattern("^[a-zA-Z0-9._/-]+$")
    path: String

    @required
    @length(min: 1, max: 500)
    message: String

    branch: String
}
```

### 4.3 Commits (files.smithy)

```smithy
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

/// Resumen de commit (para responses)
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

/// Archivo cambiado en un commit
structure CommitFile {
    @required
    filename: String

    @required
    status: String           // added, modified, deleted, renamed

    additions: Integer

    deletions: Integer

    changes: Integer

    patch: String
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
```

### 4.4 Forks (repo.smithy)

```smithy
/// Crear fork (request body)
structure ForkRepositoryBody {
    name: RepoName           // Opcional: nombre del fork

    targetOwner: String      // Opcional: owner destino
}
```

---

## 5. Notas de Implementación

### 5.1 Decisiones de Diseño

| Decisión | Razón |
|----------|-------|
| `CreateFile` usa PUT | Idempotencia - crear o actualizar por path |
| `UpdateFile` usa PATCH | Actualización parcial diferenciada de create |
| `GetRawFile` usa `/download?path=` | Flexibilidad para paths complejos |
| `CompareCommits` usa `/{base}/{head}` | Smithy no soporta `...` en URIs |
| `{filePath+}` greedy label | Captura paths con múltiples segmentos |
| `FileBytes` blob | Contenido binario con límite de 10MB |
| `RepoScopedInputMixin` | DRY para inputs con owner/repo |

### 5.2 Control de Concurrencia

Las operaciones `UpdateFile` y `DeleteFile` requieren el `sha` actual del archivo para control optimista de concurrencia. Si el sha no coincide, retorna `409 Conflict`.

### 5.3 Parámetros de DeleteFile

```
DELETE /v1/repos/{owner}/{repo}/contents/{filePath+}?sha={sha}&message={message}&branch={branch}
```

Los parámetros van en query string (no body) por restricciones HTTP de DELETE.

---

## 6. Servicios

### 6.1 FilesApi

```smithy
@title("Mini-GitHub Files API")
@restJson1
@httpBearerAuth
@documentation("Servicio para contenido de archivos, commits, descargas y comparacion de branches.")
service FilesApi {
    version: "1.0.0"
    operations: [
        GetFileContent
        GetRepositoryContents
        CreateFile
        UpdateFile
        DeleteFile
        CreateFolder
        GetRawFile
        ListCommits
        GetCommit
        GetCommitDiff
        CompareCommits
    ]
}
```

### 6.2 RepoApi (operaciones relacionadas)

Las operaciones de branches y forks están en `RepoApi` junto con otras operaciones de repositorio.

---

## 7. Estructura de Archivos

```
model/
├── common/
│   └── common.smithy       # Identity, GitObjectType, RepoScopedInputMixin
├── files/
│   └── files.smithy        # FilesApi - 11 operaciones
├── repo/
│   └── repo.smithy         # RepoApi - incluye branches y forks
├── auth/
│   └── ...                 # AuthPublicApi, AuthAccountApi
├── issue/
│   └── issue.smithy        # IssueApi
└── search/
    └── search.smithy       # SearchApi
```

---

## 8. Generación de OpenAPI

```bash
./gradlew build
```

Genera especificaciones OpenAPI separadas por servicio:
- `build/smithyprojections/mini-github-smithy/openapi-files/` → FilesApi
- `build/smithyprojections/mini-github-smithy/openapi-repo/` → RepoApi

---

## 9. Ejemplos de Uso

### 9.1 Crear archivo

```http
PUT /v1/repos/johndoe/my-repo/contents/src/main.py
Content-Type: application/json
Authorization: Bearer <token>

{
  "content": "<base64-encoded-content>",
  "message": "Add main.py",
  "branch": "main"
}
```

### 9.2 Obtener contenido de directorio

```http
GET /v1/repos/johndoe/my-repo/contents/src?ref=main
Authorization: Bearer <token>
```

### 9.3 Comparar branches

```http
GET /v1/repos/johndoe/my-repo/compare/main/feature-branch
Authorization: Bearer <token>
```

### 9.4 Crear fork

```http
POST /v1/repos/original-owner/repo-name/forks
Content-Type: application/json
Authorization: Bearer <token>

{
  "name": "my-fork"
}
```

---

## Referencias

- [Gitea API Documentation v1.20](https://docs.gitea.com/api/1.20/)
- Historias de Usuario: `C:\Python\github-docs\docs\HistoriasDeUsuario.md`
- Requisitos Funcionales: `C:\Python\github-docs\docs\RFuncionales.md`

---

**Última actualización:** 2026-04-05
**Rama:** feat/file-management
**Operaciones FilesApi:** 11
**Operaciones RepoApi relacionadas:** 7
