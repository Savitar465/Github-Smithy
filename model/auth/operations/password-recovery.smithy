$version: "2"

namespace com.minigithub.auth

use com.minigithub.common#BadRequestError
use com.minigithub.common#Email
use com.minigithub.common#InternalServerError
use com.minigithub.common#Password
use com.minigithub.common#UnauthorizedError

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

