
import UIKit


enum Fonts {
    
    enum Bold {
        static let Bold12     = {   UIFont.font(with: .bold(size: 12.0))}
        static let Bold14    = {   UIFont.font(with: .bold(size: 14.0))}
        static let Bold15      = {   UIFont.font(with: .bold(size: 15.0))}
        static let Bold16      = {   UIFont.font(with: .bold(size: 16.0))}
        static let Bold18       = {   UIFont.font(with: .bold(size: 18.0))}
        static let Bold20      = {   UIFont.font(with: .bold(size: 20.0))}
        static let Bold24      = {   UIFont.font(with: .bold(size: 24.0))}
        
        static func BoldX(size: CGFloat) -> UIFont{
            return  UIFont.font(with: .bold(size: size))
        }
    }
    
    enum Regular {
        static let Regular9      = {  UIFont.font(with: .regular(size: 9.0))}
        static let Regular11 = {  UIFont.font(with: .regular(size: 11.0))}
        static let Regular12 = {  UIFont.font(with: .regular(size: 12.0))}
        static let Regular13 = {  UIFont.font(with: .regular(size: 13.0))}
        static let Regular14     = {  UIFont.font(with: .regular(size: 14.0))}
        static let Regular15     = {  UIFont.font(with: .regular(size: 15.0))}
        static let Regular16      = {  UIFont.font(with: .regular(size: 16.0))}
        static let Regular17      = {  UIFont.font(with: .regular(size: 17.0))}
        static let Regular24      = {  UIFont.font(with: .regular(size: 24.0))}
        
        static func RegularX(size: CGFloat) -> UIFont{
            return  UIFont.font(with: .regular(size: size))
        }
    }
    
    enum Light {
        static let Light9       = {  UIFont.font(with: .light(size: 9.0))}
        static let Light12  = {  UIFont.font(with: .light(size: 12.0))}
        static let Light14     = {  UIFont.font(with: .light(size: 14.0))}
        static let Light16       = {  UIFont.font(with: .light(size: 16.0))}
        
        static func LightX(size: CGFloat) -> UIFont{
            return  UIFont.font(with: .light(size: size))
        }
    }
}


//MARK: - Private Font
fileprivate enum Private_fonts {
    
    enum Bold {
        static let caption     = {   UIFont.font(with: .bold(size: 12.0))}
        static let subtitle    = {   UIFont.font(with: .bold(size: 14.0))}
        static let middle      = {   UIFont.font(with: .bold(size: 16.0))}
        static let title       = {   UIFont.font(with: .bold(size: 18.0))}
        static let header      = {   UIFont.font(with: .bold(size: 20.0))}
    }
    
    enum Regular {
        static let tabbar      = {  UIFont.font(with: .regular(size: 9.0))}
        static let description = {  UIFont.font(with: .regular(size: 12.0))}
        static let caption     = {  UIFont.font(with: .regular(size: 14.0))}
        static let title       = {  UIFont.font(with: .regular(size: 16.0))}
    }
    
    enum Light {
        static let tabbar       = {  UIFont.font(with: .light(size: 9.0))}
        static let description  = {  UIFont.font(with: .light(size: 12.0))}
        static let caption      = {  UIFont.font(with: .light(size: 14.0))}
        static let title        = {  UIFont.font(with: .light(size: 16.0))}
    }
}


//MARK: - Shared FontStyle

enum AppFont{
    
    struct buttons {
        static let defaultValue         = { return Private_fonts.Bold.subtitle()}
        static let small                = { return Private_fonts.Bold.caption()}
        static let regularCaption       = { return Private_fonts.Regular.caption()}
        static let regularDescription   = { return Private_fonts.Regular.description()}
    }
    
    struct labels {
        static let defaultValue         = { return Private_fonts.Bold.subtitle()}
        static let title                = { return Private_fonts.Bold.title()}
        static let mid                  = { return Private_fonts.Bold.middle()}
        static let subtitle             = { return Private_fonts.Bold.subtitle()}
        static let description          = { return Private_fonts.Regular.caption()}
        static let lightDescription     = { return Private_fonts.Light.description()}
        static let lightcaption         = { return Private_fonts.Light.caption()}
        static let regularDescription   = { return Private_fonts.Regular.description()}
        static let tabbar               = { return Private_fonts.Regular.tabbar()}
    }
}


