$version: "2"

namespace com.githubx.auth

use com.githubx.common#JwtToken

structure AuthTokenDTO {
    @required
    accessToken: JwtToken

    @required
    expiresIn: Integer

    @required
    tokenType: String
}

