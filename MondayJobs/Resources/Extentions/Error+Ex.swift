

import Foundation
import Domain
extension Error {
    func getHTTPResponse() -> Domain.ResponseMessage.Base?{
        guard let response = (self as NSError).userInfo["responseError"] as? Domain.ResponseMessage.Base else{ return nil }
        return response
    }
}
