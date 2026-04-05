$version: "2"

namespace com.minigithub.auth

use com.minigithub.common#BadRequestError
use com.minigithub.common#InternalServerError
use com.minigithub.common#NotFoundError
use com.minigithub.common#UnauthorizedError
use com.minigithub.common#Url
use com.minigithub.common#Username

@http(method: "GET", uri: "/v1/auth/me", code: 200)
@readonly
@documentation("Devuelve el perfil del usuario autenticado derivado del JWT. RF01.3")
operation GetMe {
    input: Unit
    output: GetMeOutput
    errors: [
        UnauthorizedError
        InternalServerError
    ]
}

structure GetMeOutput {
    @required
    @httpPayload
    body: UserDTO
}

@http(method: "PATCH", uri: "/v1/users/me", code: 200)
@documentation("Actualiza bio, avatar, location y website del usuario. RF01.3")
operation UpdateProfile {
    input: UpdateProfileInput
    output: UpdateProfileOutput
    errors: [
        BadRequestError
        UnauthorizedError
        InternalServerError
    ]
}

structure UpdateProfileInput {
    @required
    @httpPayload
    body: UpdateProfileBody
}

structure UpdateProfileBody {
    avatarUrl: Url

    @length(max: 500)
    bio: String

    @length(max: 100)
    location: String

    website: Url
}

structure UpdateProfileOutput {
    @required
    @httpPayload
    body: UserDTO
}

@http(method: "GET", uri: "/v1/users/{username}", code: 200)
@readonly
@documentation("Devuelve el perfil publico de un usuario por su username. RF05.2")
operation GetUserByUsername {
    input: GetUserByUsernameInput
    output: GetUserByUsernameOutput
    errors: [
        UnauthorizedError
        NotFoundError
        InternalServerError
    ]
}

structure GetUserByUsernameInput {
    @required
    @httpLabel
    username: Username
}

structure GetUserByUsernameOutput {
    @required
    @httpPayload
    body: UserDTO
}

