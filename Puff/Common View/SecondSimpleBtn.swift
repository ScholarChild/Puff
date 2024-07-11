import UIKit

class SecondSimpleBtn: UIButton {
    
    convenience init() {
        self.init(frame: .zero)
        customView()
    }

    private func customView() {
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 16
        self.layer.addSublayer(bgLayer)
        self.clipsToBounds = true
    }
    
    var cornerByHalfHeight: Bool = true
    override func layoutSubviews() {
        super.layoutSubviews()
        bgLayer.frame = self.bounds
        if cornerByHalfHeight {
            bgLayer.cornerRadius = self.bounds.height / 2
        }
    }
    
    private(set) lazy var bgLayer: CAGradientLayer = {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [UIColor(red: 0.2, green: 0.62, blue: 1, alpha: 1).cgColor,
                          UIColor(red: 0.66, green: 0.28, blue: 1, alpha: 1).cgColor,
                          UIColor(red: 1, green: 0.2, blue: 0.75, alpha: 1).cgColor]
        bgLayer.locations = [0, 0.55, 1]
        bgLayer.startPoint = CGPoint(x: 0, y: 0.5)
        bgLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return bgLayer
    }()
    

    func setFontSize(_ size: CGFloat) {
        self.titleLabel?.font = UIFont(name: YHFontName.AMB, size: size)
    }
}
