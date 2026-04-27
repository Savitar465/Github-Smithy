$version: "2"

namespace com.githubx.organization

use com.githubx.common#BadRequestError
use com.githubx.common#ConflictError
use com.githubx.common#ForbiddenError
use com.githubx.common#InternalServerError
use com.githubx.common#NotFoundError
use com.githubx.common#UnauthorizedError
use com.githubx.common#Username

@http(method: "GET", uri: "/v1/orgs/{orgName}/members", code: 200)
@readonly
@documentation("Lista todos los miembros de la organización con sus roles.")
operation ListOrgMembers {
    input: OrgScopeInput
    output: ListOrgMembersOutput
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure ListOrgMembersOutput {
    @required
    @httpPayload
    body: ListOrgMembersBody
}

structure ListOrgMembersBody {
    @required
    members: OrgMemberList
}

@http(method: "POST", uri: "/v1/orgs/{orgName}/members", code: 201)
@documentation("Invita a un usuario a unirse a la organización con un rol.")
operation AddOrgMember {
    input: AddOrgMemberInput
    output: AddOrgMemberOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        ConflictError
        InternalServerError
    ]
}

structure AddOrgMemberInput {
    @required
    @httpLabel
    orgName: String

    @required
    @httpPayload
    body: AddOrgMemberBody
}

structure AddOrgMemberBody {
    @required
    username: Username

    @required
    role: OrgMemberRole
}

structure AddOrgMemberOutput {
    @required
    @httpPayload
    body: OrgMemberDTO
}

@http(method: "PATCH", uri: "/v1/orgs/{orgName}/members/{username}", code: 200)
@documentation("Cambia el rol de un miembro dentro de la organización.")
operation UpdateOrgMemberRole {
    input: UpdateOrgMemberRoleInput
    output: UpdateOrgMemberRoleOutput
    errors: [
        BadRequestError
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure UpdateOrgMemberRoleInput {
    @required
    @httpLabel
    orgName: String

    @required
    @httpLabel
    username: Username

    @required
    @httpPayload
    body: UpdateOrgMemberRoleBody
}

structure UpdateOrgMemberRoleBody {
    @required
    role: OrgMemberRole
}

structure UpdateOrgMemberRoleOutput {
    @required
    @httpPayload
    body: OrgMemberDTO
}

@http(method: "DELETE", uri: "/v1/orgs/{orgName}/members/{username}", code: 204)
@idempotent
@documentation("Elimina a un miembro de la organización y de todos sus equipos.")
operation RemoveOrgMember {
    input: RemoveOrgMemberInput
    output: Unit
    errors: [
        UnauthorizedError
        ForbiddenError
        NotFoundError
        InternalServerError
    ]
}

structure RemoveOrgMemberInput {
    @required
    @httpLabel
    orgName: String

    @required
    @httpLabel
    username: Username
}
