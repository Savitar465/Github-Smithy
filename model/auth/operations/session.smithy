$version: "2"

namespace com.githubx.auth

use com.githubx.common#BadRequestError
use com.githubx.common#Email
use com.githubx.common#InternalServerError
use com.githubx.common#Password
use com.githubx.common#UnauthorizedError

@http(method: "POST", uri: "/v1/auth/login", code: 200)
@documentation("Autentica con email y contrasena, retorna JWT. RF01.1")
operation Login {
    input: LoginInput
    output: LoginOutput
    errors: [
        BadRequestError
        UnauthorizedError
        InternalServerError
    ]
}

structure LoginInput {
    @required
    @httpPayload
    body: LoginBody
}

structure LoginBody {
    @required
    email: Email

    @required
    password: Password
}

structure LoginOutput {
    @required
    @httpPayload
    body: LoginResponseBody
}

structure LoginResponseBody {
    @required
    user: UserDTO

    @required
    token: AuthTokenDTO
}

@http(method: "POST", uri: "/v1/auth/logout", code: 204)
@documentation("Invalida el token JWT activo.")
operation Logout {
    input: Unit
    output: Unit
    errors: [
        UnauthorizedError
        InternalServerError
    ]
}

@http(method: "POST", uri: "/v1/auth/refresh", code: 200)
@documentation("Renueva el access token antes de su expiracion. RNF14")
operation RefreshToken {
    input: Unit
    output: RefreshTokenOutput
    errors: [
        UnauthorizedError
        InternalServerError
    ]
}

structure RefreshTokenOutput {
    @required
    @httpPayload
    body: AuthTokenDTO
}

