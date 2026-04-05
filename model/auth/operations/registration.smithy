$version: "2"

namespace com.minigithub.auth

use com.minigithub.common#BadRequestError
use com.minigithub.common#ConflictError
use com.minigithub.common#Email
use com.minigithub.common#InternalServerError
use com.minigithub.common#Password
use com.minigithub.common#Username

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

