import UIKit

class WindowLetValue {
    static var windowSize: CGSize {
        return UIScreen.main.bounds.size
    }
    static var windowWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var windowHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var safeAreaInsets: UIEdgeInsets {
        return keyWindow?.safeAreaInsets ?? .zero
    }
    
    static let tabbarHeight: CGFloat = 54
    
    static var keyWindow: UIWindow? {
        return currentScene?.windows
            .filter(\.isKeyWindow)
            .first
    }
    static var currentScene: UIWindowScene? {
        return UIApplication.shared.connectedScenes
            .compactMap{ $0 as? UIWindowScene }.first
    }
}

struct YHFontName {
    static let AMB = "ABCMarfa-Bold"
    /**
     Helvetica
     Helvetica-Bold
     Helvetica-BoldOblique
     Helvetica-Light
     Helvetica-LightOblique
     Helvetica-Oblique
     */
    static let Helve_Regular = "Helvetica"
    static let Helve_Bold = "Helvetica-Bold"
    static let Helve_Oblique = "Helvetica-Oblique"
    
    static let PF_SC_R = "PingFangSC-Regular"
    static let PF_SC_M = "PingFangSC-Medium"
    static let PF_SC_SB = "PingFangSC-Semibold"
}

extension UIColor {
    static func byHexStrValue(_ hex: String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIEdgeInsets {
    public init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    public init(allEdge: CGFloat) {
        self.init(top: allEdge, left: allEdge, bottom: allEdge, right: allEdge)
    }
}

