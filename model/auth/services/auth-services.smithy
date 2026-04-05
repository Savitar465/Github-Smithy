$version: "2"

namespace com.minigithub.auth

use aws.protocols#restJson1

@title("Mini-GitHub Auth Public API")
@restJson1
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

@title("Mini-GitHub Auth Account API")
@restJson1
@httpBearerAuth
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

