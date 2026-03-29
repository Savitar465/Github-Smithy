$version: "2"

namespace com.minigithub.auth
use com.minigithub.common#Uuid
use com.minigithub.common#Username
use com.minigithub.common#Email
use com.minigithub.common#Password
use com.minigithub.common#Url
use com.minigithub.common#LongText
use com.minigithub.common#JwtToken
use com.minigithub.common#BadRequestError
use com.minigithub.common#UnauthorizedError
use com.minigithub.common#ForbiddenError
use com.minigithub.common#NotFoundError
use com.minigithub.common#ConflictError
use com.minigithub.common#InternalServerError

// ─── Estructuras de datos ──────────────────────────────────────

structure UserDTO {
    @required
    id: Uuid

    @required
    username: Username

    @required
    email: Email

    avatarUrl: Url

    @length(max: 500)
    bio: String

    @length(max: 100)
    location: String

    website: Url

    @required
    createdAt: String

    @required
    updatedAt: String
}

structure AuthTokenDTO {
    @required
    accessToken: JwtToken

    @required
    expiresIn: Integer

    @required
    tokenType: String
}

// ─── HU-01: Registro ──────────────────────────────────────────

@http(method: "POST", uri: "/v1/auth/register", code: 201)
@documentation("Registra un nuevo usuario con email y contraseña. RF01.1")
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

// ─── HU-02: Login ─────────────────────────────────────────────

@http(method: "POST", uri: "/v1/auth/login", code: 200)
@documentation("Autentica con email y contraseña, retorna JWT. RF01.1")
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

// ─── Logout ───────────────────────────────────────────────────

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

// ─── Refresh Token ────────────────────────────────────────────

@http(method: "POST", uri: "/v1/auth/refresh", code: 200)
@documentation("Renueva el access token antes de su expiración. RNF14")
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

// ─── HU-05: Obtener perfil propio ─────────────────────────────

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

// ─── HU-05: Actualizar perfil ─────────────────────────────────

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

// ─── HU-03: OAuth ─────────────────────────────────────────────

@http(method: "GET", uri: "/v1/auth/oauth/{provider}", code: 200)
@readonly
@documentation("Inicia flujo OAuth con el proveedor indicado (github | google). RF01.2")
operation InitiateOAuth {
    input: InitiateOAuthInput
    output: InitiateOAuthOutput
    errors: [
        BadRequestError
        InternalServerError
    ]
}

structure InitiateOAuthInput {
    @required
    @httpLabel
    provider: OAuthProvider
}

structure InitiateOAuthOutput {
    @required
    @httpPayload
    body: InitiateOAuthBody
}

structure InitiateOAuthBody {
    @required
    redirectUrl: String
}

@http(method: "GET", uri: "/v1/auth/oauth/{provider}/callback", code: 200)
@readonly
@documentation("Callback del proveedor OAuth. Crea usuario si no existe y emite JWT. RF01.2")
operation OAuthCallback {
    input: OAuthCallbackInput
    output: OAuthCallbackOutput
    errors: [
        BadRequestError
        UnauthorizedError
        InternalServerError
    ]
}

structure OAuthCallbackInput {
    @required
    @httpLabel
    provider: OAuthProvider

    @required
    @httpQuery("code")
    code: String

    @httpQuery("state")
    state: String
}

structure OAuthCallbackOutput {
    @required
    @httpPayload
    body: LoginResponseBody
}

enum OAuthProvider {
    GITHUB = "github"
    GOOGLE = "google"
}

// ─── HU-04: Recuperación de contraseña ───────────────────────

@http(method: "POST", uri: "/v1/auth/forgot-password", code: 202)
@documentation("Envía email con enlace temporal de recuperación. RF01.4")
operation ForgotPassword {
    input: ForgotPasswordInput
    output: Unit
    errors: [
        BadRequestError
        InternalServerError
    ]
}

structure ForgotPasswordInput {
    @required
    @httpPayload
    body: ForgotPasswordBody
}

structure ForgotPasswordBody {
    @required
    email: Email
}

@http(method: "POST", uri: "/v1/auth/reset-password/{token}", code: 200)
@documentation("Cambia la contraseña usando el token de recuperación. RF01.4")
operation ResetPassword {
    input: ResetPasswordInput
    output: Unit
    errors: [
        BadRequestError
        UnauthorizedError
        InternalServerError
    ]
}

structure ResetPasswordInput {
    @required
    @httpLabel
    token: String

    @required
    @httpPayload
    body: ResetPasswordBody
}

structure ResetPasswordBody {
    @required
    newPassword: Password

    @required
    confirmPassword: Password
}

// ─── Buscar usuario por username ──────────────────────────────

@http(method: "GET", uri: "/v1/users/{username}", code: 200)
@readonly
@documentation("Devuelve el perfil público de un usuario por su username. RF05.2")
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
