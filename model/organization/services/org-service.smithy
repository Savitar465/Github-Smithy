$version: "2"

namespace com.githubx.organization

use aws.protocols#restJson1
use aws.apigateway#integration

@title("GitHub Organization Public API")
@restJson1
@integration(
    type: "http_proxy"
    uri: "https://example.com/organization/public"
    httpMethod: "POST"
)
@documentation("Operaciones públicas de organización (solo lectura sin token).")
service OrgPublicApi {
    version: "1.0.0"
    operations: [
        GetOrganization
        ListOrgRepos
    ]
}

@title("GitHub Organization API")
@restJson1
@httpBearerAuth
@integration(
    type: "http_proxy"
    uri: "https://example.com/organization"
    httpMethod: "POST"
)
@documentation("Operaciones de organización protegidas. Requiere token JWT.")
service OrgApi {
    version: "1.0.0"
    operations: [
        // Organizaciones
        ListMyOrganizations
        CreateOrganization
        UpdateOrganization
        DeleteOrganization

        // Miembros de la organización
        ListOrgMembers
        AddOrgMember
        UpdateOrgMemberRole
        RemoveOrgMember

        // Equipos
        ListOrgTeams
        CreateTeam
        GetTeam
        UpdateTeam
        DeleteTeam

        // Miembros del equipo
        ListTeamMembers
        AddTeamMember
        RemoveTeamMember

        // Repositorios del equipo
        ListTeamRepos
        AddTeamRepo
        RemoveTeamRepo
    ]
}
