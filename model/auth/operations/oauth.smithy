$version: "2"

namespace com.githubx.auth

use com.githubx.common#BadRequestError
use com.githubx.common#InternalServerError
use com.githubx.common#UnauthorizedError

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

