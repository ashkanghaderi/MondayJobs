
import Foundation
import Kingfisher
import NetworkPlatform

let modifier = AnyModifier { request in
    var r = request
    r.setValue("Bearer \(AuthorizationInfo.get(by: "jwt_token") ?? "")", forHTTPHeaderField: "Authorization")
    return r
}
