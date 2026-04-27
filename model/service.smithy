$version: "2"

namespace com.githubx

use aws.protocols#restJson1

@title("GitHub Unified API")
@restJson1
@documentation("Servicio agregador de referencia documental. Reutiliza operaciones de los servicios por dominio en com.githubx.*")
service GitHubApi {
    version: "1.0.0"
    rename: {
        "com.githubx.issue#AuthorSummary": "IssueAuthorSummary"
        "com.githubx.pullrequest#AuthorSummary": "PullRequestAuthorSummary"
    }
    operations: [
        // Auth Public
        com.githubx.auth#Register
        com.githubx.auth#Login
        com.githubx.auth#InitiateOAuth
        com.githubx.auth#OAuthCallback
        com.githubx.auth#ForgotPassword
        com.githubx.auth#ResetPassword

        // Auth Account
        com.githubx.auth#Logout
        com.githubx.auth#RefreshToken
        com.githubx.auth#GetMe
        com.githubx.auth#UpdateProfile
        com.githubx.auth#GetUserByUsername

        // Repo
        com.githubx.repo#ListMyRepositories
        com.githubx.repo#CreateRepository
        com.githubx.repo#GetRepository
        com.githubx.repo#UpdateRepository
        com.githubx.repo#DeleteRepository
        com.githubx.repo#ForkRepository
        com.githubx.repo#ListRepositoryForks
        com.githubx.repo#ListBranches
        com.githubx.repo#GetBranch
        com.githubx.repo#CreateBranch
        com.githubx.repo#DeleteBranch
        com.githubx.repo#ListCollaborators
        com.githubx.repo#GetCollaborator
        com.githubx.repo#AddCollaboratorByUsername
        com.githubx.repo#AddCollaboratorWithRole
        com.githubx.repo#UpdateCollaboratorRole
        com.githubx.repo#RemoveCollaborator

        // Files
        com.githubx.files#GetFileContent
        com.githubx.files#GetRepositoryContents
        com.githubx.files#CreateFile
        com.githubx.files#UpdateFile
        com.githubx.files#DeleteFile
        com.githubx.files#CreateFolder
        com.githubx.files#GetRawFile
        com.githubx.files#ListCommits
        com.githubx.files#GetCommit
        com.githubx.files#GetCommitDiff
        com.githubx.files#CompareCommits

        // Issue + Issue Comments
        com.githubx.issue#ListIssues
        com.githubx.issue#CreateIssue
        com.githubx.issue#GetIssue
        com.githubx.issue#UpdateIssue
        com.githubx.issue#ListIssueComments
        com.githubx.issue#CreateIssueComment
        com.githubx.issue#ListLabels
        com.githubx.issue#CreateLabel

        // Pull Requests
        com.githubx.pullrequest#ListPullRequests
        com.githubx.pullrequest#CreatePullRequest
        com.githubx.pullrequest#GetPullRequest
        com.githubx.pullrequest#ReviewPullRequest
        com.githubx.pullrequest#MergePullRequest
        com.githubx.pullrequest#ListPullRequestComments
        com.githubx.pullrequest#CreatePullRequestComment
        com.githubx.pullrequest#GetPullRequestMergeability

        // Search
        com.githubx.search#SearchRepositories
        com.githubx.search#SearchUsers
        com.githubx.search#SearchIssues

        // Organization
        com.githubx.organization#GetOrganization
        com.githubx.organization#ListOrgRepos
        com.githubx.organization#ListMyOrganizations
        com.githubx.organization#CreateOrganization
        com.githubx.organization#UpdateOrganization
        com.githubx.organization#DeleteOrganization
        com.githubx.organization#ListOrgMembers
        com.githubx.organization#AddOrgMember
        com.githubx.organization#UpdateOrgMemberRole
        com.githubx.organization#RemoveOrgMember
        com.githubx.organization#ListOrgTeams
        com.githubx.organization#CreateTeam
        com.githubx.organization#GetTeam
        com.githubx.organization#UpdateTeam
        com.githubx.organization#DeleteTeam
        com.githubx.organization#ListTeamMembers
        com.githubx.organization#AddTeamMember
        com.githubx.organization#RemoveTeamMember
        com.githubx.organization#ListTeamRepos
        com.githubx.organization#AddTeamRepo
        com.githubx.organization#RemoveTeamRepo
    ]
}
