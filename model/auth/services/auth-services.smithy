$version: "2"

namespace com.githubx.auth

use aws.protocols#restJson1
use aws.apigateway#integration

@title("GitHub Auth Public API")
@restJson1
@integration(
    type: "http_proxy"
    uri: "https://example.com/auth/public"
    httpMethod: "POST"
)
@documentation("Servicio publico de autenticacion sin token previo.")
service AuthPublicApi {
    version: "1.0.0"
    operations: [
        Register
        Login
        InitiateOAuth
        OAuthCallback
        ForgotPassword
        ResetPassword
    ]
}

@title("GitHub Auth Account API")
@restJson1
@httpBearerAuth
@integration(
    type: "http_proxy"
    uri: "https://example.com/auth/account"
    httpMethod: "POST"
)
@documentation("Servicio protegido para operaciones de cuenta autenticada.")
service AuthAccountApi {
    version: "1.0.0"
    operations: [
        Logout
        RefreshToken
        GetMe
        UpdateProfile
        GetUserByUsername
    ]
}

