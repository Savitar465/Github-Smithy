$version: "2"

namespace com.githubx.organization

use com.githubx.common#RepoName
use com.githubx.common#Uuid
use com.githubx.common#PaginationMeta

structure OrgRepoSummary {
    @required
    id: Uuid

    @required
    name: RepoName

    @required
    fullName: String

    description: String

    @required
    starsCount: Integer

    @required
    updatedAt: String
}

list OrgRepoList {
    member: OrgRepoSummary
}

structure ListOrgReposBody {
    @required
    repositories: OrgRepoList

    @required
    pagination: PaginationMeta
}
