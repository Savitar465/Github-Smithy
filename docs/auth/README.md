# Auth Model Guide

La carpeta `model/auth` contiene solo archivos `.smithy` para evitar warnings del build.

## Estructura

- `model/auth/auth.smithy`: indice del modulo auth.
- `model/auth/types/`: shapes reutilizables del dominio.
  - `user.smithy`: perfil de usuario (`UserDTO`).
  - `token.smithy`: token de autenticacion (`AuthTokenDTO`).
  - `oauth.smithy`: proveedor OAuth (`OAuthProvider`).
- `model/auth/operations/`: operaciones agrupadas por caso de uso.
- `model/auth/services/`: definiciones de servicio para el dominio auth.
  - `auth-services.smithy`: `AuthPublicApi` y `AuthAccountApi`.

## Convenciones

- Mantener `namespace com.minigithub.auth` en todo el modulo.
- No renombrar shapes existentes para no romper contratos.
- Cada archivo de operaciones define solo su `operation` y sus `Input/Output/Body`.
- Reutilizar shapes comunes desde `types/` en lugar de duplicarlos.

## Codegen cliente y server

- Proyecciones OpenAPI auth:
  - `openapi-auth-public` -> `com.minigithub.auth#AuthPublicApi`
  - `openapi-auth-account` -> `com.minigithub.auth#AuthAccountApi`
- Tareas Gradle Java:
  - `generateAuthJavaClient` -> cliente Java desde `AuthPublicApi`
  - `generateAuthJavaServer` -> stubs Spring Java desde `AuthAccountApi`
  - `generateAuthJava` -> ejecuta ambos flujos
- Comandos:
  - `./gradlew smithyBuild`
  - `./gradlew generateAuthJava`

