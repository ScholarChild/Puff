import UIKit
import SnapKit

class LicenseWarningAlert: UIViewController {
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(white: 0, alpha: 0.3)
        
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(240)
        }
        
        let logo = UIImageView(image: UIImage(named: "login_warningAlert_logo"))
        contentView.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(licenseTipView)
        licenseTipView.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        initLeftBtn()
        initRightBtn()
        
        let btnStack = UIStackView(arrangedSubviews: [leftBtn, rightBtn])
        btnStack.distribution = .fillEqually
        btnStack.spacing = 10
        contentView.addSubview(btnStack)
        btnStack.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(licenseTipView.snp.bottom).offset(10)
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
        let contentView = UIView()
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private let leftBtn = UIButton()
    private func initLeftBtn() {
        leftBtn.backgroundColor = UIColor(white: 0.75, alpha: 1)
        leftBtn.setTitle("Later", for: .normal)
        leftBtn.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
        leftBtn.titleLabel?.font = UIFont(name: YHFontName.AMB, size: 16)
        leftBtn.addTarget(self, action: #selector(didTouchLaterBtn), for: .touchUpInside)
    }
    
    private let rightBtn = SecondSimpleBtn()
    private func initRightBtn() {
        rightBtn.setFontSize(16)
        rightBtn.setTitle("Agree", for: .normal)
        rightBtn.addTarget(self, action: #selector(didTouchAgreeBtn), for: .touchUpInside)
    }
    
    private lazy var licenseTipView: UIView = {
        let text = "By using our App you agree with our Terms & Conditions and Privacy Policy"
        let terms_name = "Terms & Conditions"
        let policy_name = "Privacy Policy"
        let terms_range = NSRange(text.range(of: terms_name)!, in: text)
        let policy_range = NSRange(text.range(of: policy_name)!, in: text)
        let attr = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont(name: YHFontName.PF_SC_R, size: 14)!,
            .foregroundColor: UIColor(white: 0.15, alpha: 1)
        ])
        let lineColor = UIColor.byHexStrValue("#349DFE")
        let linkAttr: [NSAttributedString.Key: Any] = [
            .foregroundColor: lineColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: lineColor,
        ]
        attr.addAttributes(linkAttr, range: terms_range)
        attr.addAttributes(linkAttr, range: policy_range)

        let label = UILabel()
        label.attributedText = attr
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var didAgreeAction: () -> Void = {}
    @objc private func didTouchAgreeBtn() {
        didAgreeAction()
        self.dismiss(animated: true)
    }
    
    @objc private func didTouchLaterBtn() {
        self.dismiss(animated: true)
    }
    //残留的混淆垃圾代码
    private lazy var agreeBtn: UIButton = {
        let btn = SecondSimpleBtn()
        btn.setFontSize(16)
        btn.setTitle("Agree and Continue", for: .normal)
        btn.addTarget(self, action: #selector(didTouchAgreeBtn), for: .touchUpInside)
        btn.layer.cornerRadius = 36 / 2
        return btn
    }()
    
    private lazy var laterBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Later", for: .normal)
        btn.setTitleColor(UIColor(white: 0.75, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont(name: YHFontName.PF_SC_SB, size: 14)
        btn.addTarget(self, action: #selector(didTouchLaterBtn), for: .touchUpInside)
        return btn
    }()
}
