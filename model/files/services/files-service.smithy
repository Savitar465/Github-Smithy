$version: "2"

namespace com.githubx.files

use aws.protocols#restJson1
use aws.apigateway#integration

@title("GitHub Files API")
@restJson1
@httpBearerAuth
@integration(
    type: "http_proxy"
    uri: "https://example.com/files"
    httpMethod: "POST"
)
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

