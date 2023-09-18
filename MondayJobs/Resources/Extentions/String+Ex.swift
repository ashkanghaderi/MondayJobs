
import Foundation
import Domain
import UIKit

extension Optional where Wrapped == String {
    
    var isEmptyOrBlank: Bool {
        switch self {
        case .some(let aString):
            return aString.isEmptyOrBlank
        case .none:
            return true
        }
    }
    
}


extension String {
    
    
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
    
    var isEmptyOrBlank: Bool {
        return self.isEmptyOrBlankString()
    }
    
    func isEmptyOrBlankString() -> Bool {
        
        guard !self.isEmpty else { return true}
        
        guard self.trimmingCharacters(in: CharacterSet.whitespaces).count != 0 else {
            return true
        }
        
        guard self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count != 0 else {
            return true
        }
        
        return false
    }
    
    func forImageURL() -> String{
        return BaseURL.dev.rawValue  + self
    }
    
    func hexColor (alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hex: self,alpha:alpha )
    }
    
    func toAttributedString(color: UIColor, font: UIFont) -> NSMutableAttributedString{
        let attribute = [ NSAttributedString.Key.font: font ,NSAttributedString.Key.foregroundColor: color]
        let preString = NSMutableAttributedString(string: self, attributes: attribute)
        return preString
    }
    
    func isValidPhoneNumber() -> Bool {
        
        var phone = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if phone.isEmpty {
            return false
        }
        
        let phoneRegex = "^09[0-9'@s]{9,9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let result =  phoneTest.evaluate(with: phone)
        return result
    }
    
    func isValidEmail()-> Bool {
        
        var emailAddress = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if emailAddress.isEmpty {
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailAddress)
    }
    

    var htmlToAttributedString: NSAttributedString? {
          guard let data = data(using: .utf8) else { return NSAttributedString() }
          do {
              return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
          } catch {
              return NSAttributedString()
          }
      }
      
      var htmlToString: String {
          return htmlToAttributedString?.string ?? ""
      }
    
    func base64Encoded() -> String? {
           if let data = self.data(using: .utf8) {
               return data.base64EncodedString()
           }
           return nil
       }

       func capitalizingFirstLetter() -> String {
           return prefix(1).uppercased() + dropFirst()
       }
       
       mutating func capitalizeFirstLetter() {
           self = self.capitalizingFirstLetter()
       }
    
}


extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }

    
    var spaceReduced: String {
        let chars = self.unicodeScalars.flatMap { unicode -> String in
            if CharacterSet.whitespaces.contains(unicode) {
                return ""
            }
            return String(unicode)
        }
        return String(chars)
    }
    
    var extractCellNumberLike: String? {
        let str = self
        if str.hasPrefix("0") {
            return str.spaceReduced.digits
        }
        else if hasPrefix("+") {
            let s = String(str[index(str.startIndex, offsetBy: 1)...])
            return "+" + s.spaceReduced.digits
        }
        return nil
    }
    
    var digits: String {
        return self.compactMap { Int(String($0)) }.reduce("") { $0 + String($1) }
    }
    
    var ibanFormatted: String {
        if self.count <= 2 {
            return String(self[self.startIndex..<self.index(self.startIndex,
                                                            offsetBy: self.count)])
        }
        
        var finalString = "-" + self[self.startIndex ..< self.index(self.startIndex, offsetBy: 2)]
        
        let subString = String(self[index(self.startIndex, offsetBy: 2)...])
        finalString += subString.enumerated().reduce("") { $0 + ($1.offset % 4 == 0 ? (" - " + String($1.element)) : String($1.element)) }
        
        finalString.removeFirst()
        
        return finalString
    }
    
    var telephoneFormatted: String {
        if let res = self.match(regex: ""),
            res.1.lowerBound == 0, res.0.count < self.count {
            
            return String(self[..<self.index(self.startIndex, offsetBy: res.1.count)]) +
                "-" +
                String(self[self.index(self.startIndex, offsetBy: res.1.count)...])
        }
        return self
    }
    
    var phoneFormater: String {
        return formattedNumber(number: self, mask: "XXXX XXX XXXX")
    }
    
    var cellPhoneFormatted: String {
        return formattedNumber(number: self, mask: "XXXX XXX XXXX")
    }
    
    
    var cardFormatted: String {
        var finalString: String = ""
        
        finalString = self.enumerated().reduce("") { $0 + ($1.offset % 4 == 0 ? ("-" + String($1.element)) : String($1.element)) }
        
        if finalString.count != 0 {
            finalString.removeFirst()
        }
        
        return finalString
    }
    var maskCard: String {
        var resultString = ""
        self.enumerated().forEach { (index, character) in
            if index < 12 && index > 5  {
                resultString += "x"
            } else {
                resultString.append(character)
            }
        }
        return resultString.cardFormatted
    }
   
    
    
    var isPhoneNumber: Bool {
        if count >= 2 {
            if hasPrefix("09") {
                return true
            }
        } else {
            return true
        }
        return false
    }
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    
    var removeLeadingZero: String {
        let str = self
        
        let zero = str.prefix(while: { $0 == "0"})
        return String(str[str.index(str.startIndex, offsetBy: zero.count)...])
    }
    

    func match(regex: String) -> (String, CountableRange<Int>)? {
        guard let expression = try? NSRegularExpression(pattern: regex, options: []) else { return nil }
        let range = expression.rangeOfFirstMatch(in: self, options: [], range: NSRange(0 ..< self.utf16.count))
        if range.location != NSNotFound {
            return ((self as NSString).substring(with: range), range.location ..< range.location + range.length )
        }
        return nil
    }
    
    func formattedNumber(number: String, mask: String = "+X (XXX) XXX-XXXX") -> String {
        
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
   
    
    func incrementalSearch(with str: String) -> Bool {
        let chars = str
        var index = 0
        for char in self {
            if index == chars.count {
                break
            }
            if chars[chars.index(chars.startIndex, offsetBy: index)] == char {
                index += 1
            }
        }
        return index == chars.count
    }
    
    func search(with str: String) -> Bool {
        return localizedCaseInsensitiveContains(str)
        //        return contains(str)
    }
    
    
}

extension String{
    mutating func convertHtml() -> NSAttributedString?{
        do {
            if self != "" {
                self = "<html><body dir=\"rtl\">"+self+"</body></html>"
            }
            return try NSAttributedString(data: Data(self.utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            //print("error: ", error)
            return nil
        }
    }
}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self.base64urlToBase64()) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func dataFromBase64() -> Data? {
        
        guard let data = Data(base64Encoded: self.base64urlToBase64()) else {
            return nil
        }
        
        return data
    }
    
    func base64urlToBase64() -> String {
        var base64 = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        
        return base64
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension String{
    func toDate(format : String) -> Date{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)!
    }
}
