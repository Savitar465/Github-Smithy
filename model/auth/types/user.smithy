$version: "2"

namespace com.minigithub.auth

use com.minigithub.common#Email
use com.minigithub.common#Url
use com.minigithub.common#Username
use com.minigithub.common#Uuid

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

