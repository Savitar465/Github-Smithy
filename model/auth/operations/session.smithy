$version: "2"

namespace com.minigithub.auth

use com.minigithub.common#BadRequestError
use com.minigithub.common#Email
use com.minigithub.common#InternalServerError
use com.minigithub.common#Password
use com.minigithub.common#UnauthorizedError

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

