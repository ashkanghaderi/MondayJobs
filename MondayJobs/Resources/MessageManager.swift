
import Foundation
import UIKit

protocol Messagable {
    var message: Message { get }
    var theme: MessageTheme? { get }
    var canRetry: Bool { get }
}

extension Messagable {
    var theme: MessageTheme? {
        return .default
    }
}

// MARK:- TODO: duplicate fix it with snack bar view
struct Action {
    let title: String
    let action: () -> Void
    
}

struct Message {
    let title: String
    let duration: TimeInterval
    let description: String?
    let icon: UIImage?
    let apiError: String?
//    let statusCode: Int?
    /// if not nil, icon will be replaced with retry icon
    var action: Action?
    
    init(title: String = "",
         duration: TimeInterval = 3.0,
         description: String? = nil,
         icon: UIImage? = nil, action: Action? = nil,
         apiError: String? = nil) {
        
        self.title = title
        self.duration = duration
        self.description = description
        self.icon = icon
        self.action = action
        self.apiError = apiError
//        self.statusCode = 0
        
    }
}

struct MessageTheme {
    let background: UIColor
    let tint: UIColor
}

extension MessageTheme {
    static let `default` = MessageTheme(background: UIColor.lightGray, tint: UIColor.black)
    
    static let error = MessageTheme(background: UIColor.red,
                                    tint: .white)
    
    static let warning = MessageTheme(background: UIColor.orange,
                                      tint: .white)
    
    static let info = MessageTheme(background: UIColor.green,
                                   tint: .white)
}
