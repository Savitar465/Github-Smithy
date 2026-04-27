$version: "2"

namespace com.githubx.auth

use com.githubx.common#Email
use com.githubx.common#Url
use com.githubx.common#Username
use com.githubx.common#Uuid

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

