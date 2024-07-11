import UIKit
import SnapKit

class YHBaseServiceViewController: UIViewController {
    
    func addPageBackground() {
        let bgView = UIImageView(image: UIImage(named: "common_basePage_pageBackground"))
        bgView.contentMode = .scaleAspectFill
        view.addSubview(bgView)
        view.sendSubviewToBack(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    enum BackStyle {
        case white
        case black
    }
    
    func addNaviBackItem(style: BackStyle = .white) {
        let btn = UIControl()
        btn.addTarget(self, action: #selector(didTouchPageBackItem), for: .touchUpInside)
        let icon: UIImage
        switch style {
            case .white:
                icon = UIImage(named: "base_navi_back_white")!
            case .black:
                icon = UIImage(named: "base_navi_back_black")!
        }
        let iconView = UIImageView(image: icon)
        btn.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(5)
        }
        naviView.setLeftItem(view: btn, inset: 0)
    }
    
    func setNaviTitle(_ title: String) {
        naviView.titleLabel.text = title
    }
    
    private(set) lazy var naviView: NaviBar = {
        let naviBar = NaviBar()
        self.view.addSubview(naviBar)
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        return naviBar
    }()
    
    @objc private func didTouchPageBackItem() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension YHBaseServiceViewController {
    
    class NaviBar: UIView {
        private var leftItem: UIView? = nil
        func setLeftItem(view: UIView, inset: CGFloat = 18) {
            if let currentItem = leftItem {
                currentItem.removeFromSuperview()
            }
            
            addSubview(view)
            view.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(inset)
            }
            leftItem = view
        }
        
        private var rightItem: UIView? = nil
        func setRightItem(view: UIView, inset: CGFloat = 18) {
            if let currentItem = rightItem {
                currentItem.removeFromSuperview()
            }
            
            addSubview(view)
            view.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(inset)
            }
            rightItem = view
            
        }
        
        private(set) lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont(name: YHFontName.Helve_Bold, size: 22)
            addSubview(label)
            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            return label
        }()
    }
}
