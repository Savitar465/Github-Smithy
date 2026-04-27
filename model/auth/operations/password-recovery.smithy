$version: "2"

namespace com.githubx.auth

use com.githubx.common#BadRequestError
use com.githubx.common#Email
use com.githubx.common#InternalServerError
use com.githubx.common#Password
use com.githubx.common#UnauthorizedError

@http(method: "POST", uri: "/v1/auth/forgot-password", code: 202)
@documentation("Envia email con enlace temporal de recuperacion. RF01.4")
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
@documentation("Cambia la contrasena usando el token de recuperacion. RF01.4")
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

