$version: "2"

namespace com.minigithub

use aws.protocols#restJson1

use com.minigithub.auth#Register
use com.minigithub.auth#Login
use com.minigithub.auth#Logout
use com.minigithub.auth#RefreshToken
use com.minigithub.auth#GetMe
use com.minigithub.auth#UpdateProfile
use com.minigithub.auth#InitiateOAuth
use com.minigithub.auth#OAuthCallback
use com.minigithub.auth#ForgotPassword
use com.minigithub.auth#ResetPassword
use com.minigithub.auth#GetUserByUsername

use com.minigithub.repo#ListMyRepositories
use com.minigithub.repo#CreateRepository
use com.minigithub.repo#GetRepository
use com.minigithub.repo#UpdateRepository
use com.minigithub.repo#DeleteRepository
use com.minigithub.repo#DownloadArchive
use com.minigithub.repo#ListBranches
use com.minigithub.repo#CreateBranch
use com.minigithub.repo#DeleteBranch
use com.minigithub.repo#GetBranch
use com.minigithub.repo#ForkRepository
use com.minigithub.repo#ListForks
use com.minigithub.repo#StarRepository
use com.minigithub.repo#UnstarRepository
use com.minigithub.repo#ListCollaborators
use com.minigithub.repo#AddCollaborator
use com.minigithub.repo#UpdateCollaboratorRole
use com.minigithub.repo#RemoveCollaborator

use com.minigithub.files#GetFileContent
use com.minigithub.files#CreateFile
use com.minigithub.files#UpdateFile
use com.minigithub.files#DeleteFile
use com.minigithub.files#CreateFolder
use com.minigithub.files#GetRawFile
use com.minigithub.files#ListCommits
use com.minigithub.files#GetCommit
use com.minigithub.files#GetCommitDiff
use com.minigithub.files#CompareCommits

use com.minigithub.issue#ListIssues
use com.minigithub.issue#CreateIssue
use com.minigithub.issue#GetIssue
use com.minigithub.issue#UpdateIssue
use com.minigithub.issue#ListIssueComments
use com.minigithub.issue#CreateIssueComment
use com.minigithub.issue#ListLabels
use com.minigithub.issue#CreateLabel
use com.minigithub.issue#ListPullRequests
use com.minigithub.issue#CreatePullRequest
use com.minigithub.issue#GetPullRequest
use com.minigithub.issue#ReviewPullRequest
use com.minigithub.issue#MergePullRequest

use com.minigithub.search#SearchRepositories
use com.minigithub.search#SearchUsers
use com.minigithub.search#SearchIssues

@title("Mini-GitHub API")
@restJson1
@httpBearerAuth
@documentation("API REST de Mini-GitHub. Proyecto académico de Arquitectura en la Nube y Microservicios.")
service MiniGitHubApi {
    version: "1.0.0"
    operations: [
        // Auth Service — puerto 3001
        Register
        Login
        Logout
        RefreshToken
        GetMe
        UpdateProfile
        InitiateOAuth
        OAuthCallback
        ForgotPassword
        ResetPassword
        GetUserByUsername

        // Repo Service — puerto 3002
        ListMyRepositories
        CreateRepository
        GetRepository
        UpdateRepository
        DeleteRepository
        DownloadArchive
        ListBranches
        CreateBranch
        DeleteBranch
        GetBranch
        ForkRepository
        ListForks
        StarRepository
        UnstarRepository
        ListCollaborators
        AddCollaborator
        UpdateCollaboratorRole
        RemoveCollaborator

        // Files Service — puerto 3002 (parte del repo service)
        GetFileContent
        CreateFile
        UpdateFile
        DeleteFile
        CreateFolder
        GetRawFile
        ListCommits
        GetCommit
        GetCommitDiff
        CompareCommits

        // Issue Service — puerto 3003
        ListIssues
        CreateIssue
        GetIssue
        UpdateIssue
        ListIssueComments
        CreateIssueComment
        ListLabels
        CreateLabel
        ListPullRequests
        CreatePullRequest
        GetPullRequest
        ReviewPullRequest
        MergePullRequest

        // Search Service — puerto 3004
        SearchRepositories
        SearchUsers
        SearchIssues
    ]
}
