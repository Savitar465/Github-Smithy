$version: "2"

namespace com.githubx.pullrequest

use aws.protocols#restJson1
use aws.apigateway#integration

@title("GitHub Pull Request API")
@restJson1
@httpBearerAuth
@integration(
    type: "http_proxy"
    uri: "https://example.com/pullrequest"
    httpMethod: "POST"
)
@documentation("Servicio dedicado para pull requests y comentarios de pull requests.")
service PullRequestApi {
    version: "1.0.0"
    operations: [
        ListPullRequests
        CreatePullRequest
        GetPullRequest
        ReviewPullRequest
        MergePullRequest
        ListPullRequestComments
        CreatePullRequestComment
        GetPullRequestMergeability
    ]
}
