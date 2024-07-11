import UIKit

class RanbowColorView: UIView {
    // 便利初始化方法
    convenience init() {
        self.init(frame: .zero)
        addBgLayer()
    }
    
    // 渐变层属性
    private let bgLayer = CAGradientLayer()
    
    // 控制是否根据高度设置圆角的属性
    var isSetCornerByHeight = false
    
    // 重写 layoutSubviews 方法，以更新渐变层的框架和圆角
    override func layoutSubviews() {
        super.layoutSubviews()
        bgLayer.frame = self.bounds
        
        if isSetCornerByHeight {
            self.layer.cornerRadius = self.bounds.height / 2
            self.layer.masksToBounds = true
        }
    }
    
    // 配置渐变层的方法
    private func addBgLayer() {
        bgLayer.colors = [ UIColor(red: 0.44, green: 0, blue: 1, alpha: 1).cgColor,
                           UIColor(red: 0.75, green: 0, blue: 1, alpha: 1).cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer.endPoint = CGPoint(x: 0.5, y: 1)
        self.layer.insertSublayer(bgLayer, at: 0)
    }
}

