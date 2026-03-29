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
use com.minigithub.repo#GetRepoContents
use com.minigithub.repo#UploadFile
use com.minigithub.repo#DeleteFile
use com.minigithub.repo#DownloadArchive
use com.minigithub.repo#ListBranches
use com.minigithub.repo#CreateBranch
use com.minigithub.repo#DeleteBranch
use com.minigithub.repo#StarRepository
use com.minigithub.repo#UnstarRepository
use com.minigithub.repo#ListCollaborators
use com.minigithub.repo#AddCollaborator
use com.minigithub.repo#UpdateCollaboratorRole
use com.minigithub.repo#RemoveCollaborator

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
        GetRepoContents
        UploadFile
        DeleteFile
        DownloadArchive
        ListBranches
        CreateBranch
        DeleteBranch
        StarRepository
        UnstarRepository
        ListCollaborators
        AddCollaborator
        UpdateCollaboratorRole
        RemoveCollaborator

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
