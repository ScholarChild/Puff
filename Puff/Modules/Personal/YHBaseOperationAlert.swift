//

import UIKit
import SnapKit

class YHBaseOperationAlert: UIViewController {
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(270)
            make.height.greaterThanOrEqualTo(150)
        }
        
        let iconView = UIImageView(image: UIImage(named: "operationAlert_topIcon"))
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        
        let msgLabel = UILabel()
        msgLabel.text = self.msg
        msgLabel.textColor = .black
        msgLabel.textAlignment = .center
        msgLabel.font = UIFont(name: YHFontName.PF_SC_M, size: 16)
        msgLabel.numberOfLines = 0
        contentView.addSubview(msgLabel)
        msgLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
        }
        
        let leftBtn = UIButton()
        leftBtn.backgroundColor = UIColor(white: 0.75, alpha: 1)
        leftBtn.setTitle(leftTitle, for: .normal)
        leftBtn.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        leftBtn.titleLabel?.font = UIFont(name: YHFontName.AMB, size: 16)
        leftBtn.addTarget(self, action: #selector(didTouchLeftBtn), for: .touchUpInside)
        
        let rightBtn = SecondSimpleBtn()
        rightBtn.setFontSize(16)
        rightBtn.setTitle(rightTitle, for: .normal)
        rightBtn.addTarget(self, action: #selector(didTouchRightBtn), for: .touchUpInside)
        
        let btnStack = UIStackView(arrangedSubviews: [leftBtn, rightBtn])
        btnStack.distribution = .fillEqually
        btnStack.spacing = 10
        contentView.addSubview(btnStack)
        btnStack.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(msgLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        for btn in [leftBtn, rightBtn] {
            btn.layer.cornerRadius = 36 / 2
            btn.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 90, height: 36))
            }
        }
    }
    
    private lazy var contentView: UIView = {
        let imageView = UIView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    var msg = ""
    var leftTitle = ""
    var rightTitle = ""
    
    var leftBtnAction: () -> Void = {}
    @objc private func didTouchLeftBtn() {
        dismiss(animated: true)
        leftBtnAction()
    }
    
    var rightBtnAction: () -> Void = {}
    @objc private func didTouchRightBtn() {
        dismiss(animated: true)
        rightBtnAction()
    }
}
