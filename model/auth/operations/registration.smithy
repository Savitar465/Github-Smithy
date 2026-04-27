$version: "2"

namespace com.githubx.auth

use com.githubx.common#BadRequestError
use com.githubx.common#ConflictError
use com.githubx.common#Email
use com.githubx.common#InternalServerError
use com.githubx.common#Password
use com.githubx.common#Username

@http(method: "POST", uri: "/v1/auth/register", code: 201)
@documentation("Registra un nuevo usuario con email y contrasena. RF01.1")
operation Register {
    input: RegisterInput
    output: RegisterOutput
    errors: [
        BadRequestError
        ConflictError
        InternalServerError
    ]
}

structure RegisterInput {
    @required
    @httpPayload
    body: RegisterBody
}

structure RegisterBody {
    @required
    username: Username

    @required
    email: Email

    @required
    password: Password

    @required
    confirmPassword: Password
}

structure RegisterOutput {
    @required
    @httpPayload
    body: RegisterResponseBody
}

structure RegisterResponseBody {
    @required
    user: UserDTO

    @required
    token: AuthTokenDTO
}

