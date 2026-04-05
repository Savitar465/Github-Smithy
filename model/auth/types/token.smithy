$version: "2"

namespace com.minigithub.auth

use com.minigithub.common#JwtToken

structure AuthTokenDTO {
    @required
    accessToken: JwtToken

    @required
    expiresIn: Integer

    @required
    tokenType: String
}

