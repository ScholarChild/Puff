import UIKit

extension AccountSetupController {
    class LicenseView: UIView, UITextViewDelegate {
        override init(frame: CGRect) {
            super.init(frame: frame)
            customView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func customView() {
            addSubview(textView)
            textView.snp.makeConstraints { make in
                make.top.bottom.right.equalToSuperview()
                make.height.equalTo(50)
                make.width.equalTo(240)
            }
            checkBtn.setImage(UIImage(named: "login_checkMark_unselect"), for: .normal)
            checkBtn.setImage(UIImage(named: "login_checkMark_selected"), for: .selected)
            checkBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 20, right: 6)
            checkBtn.addTarget(self, action: #selector(didTouchSwitch), for: .touchUpInside)
            addSubview(checkBtn)
            checkBtn.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.right.equalTo(textView.snp.left)
            }
        }
        
        private let checkBtn = UIButton()
        private lazy var textView: UITextView = {
            let textView = UITextView()
            let tintColor = UIColor.byHexStrValue("#349DFE")
            textView.linkTextAttributes = [
                .foregroundColor: tintColor,
                .underlineColor: tintColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            textView.attributedText = protocolAttr
            textView.textAlignment = .center
            textView.textAlignment = .center
            textView.isEditable = false
            textView.isScrollEnabled = false
            textView.delegate = self
            textView.isScrollEnabled = false
            textView.backgroundColor = .clear
            return textView
        }()
        
        lazy var protocolAttr: NSAttributedString = {
            let fullText = "By continuing, you agree with our Terms & Conditions and Privacy Policy."
            let termName = "Terms & Conditions"
            let policyName = "Privacy Policy"
            let termURL = ProjGlobalInfo.termPageURL
            let policyURL = ProjGlobalInfo.privacyPageURL
            
            let protocolAttr = NSMutableAttributedString(string: fullText, attributes: [
                .font: UIFont(name: YHFontName.PF_SC_R, size: 12)!,
                .foregroundColor: UIColor.white
            ])
            for idx in 0 ..< 2 {
                let protocolName = [termName, policyName][idx]
                let path = [termURL, policyURL][idx]
                let textRange = NSRange(fullText.range(of: protocolName)!, in: fullText)
                protocolAttr.addAttribute(.link, value: path, range: textRange)
            }
            return protocolAttr
        }()
        
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
            return true;
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            textView.endEditing(true)
        }
        
        @objc private func didTouchSwitch() {
            isAgreesLicense.toggle()
        }
        
        var isAgreesLicense: Bool = false {
            didSet { checkBtn.isSelected = isAgreesLicense }
        }
    }
}

