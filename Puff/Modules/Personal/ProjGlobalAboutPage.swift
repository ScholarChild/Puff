import UIKit
import SnapKit
import StoreKit

class ProjGlobalAboutPage: YHBaseServiceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .byHexStrValue("F8F8F8")
        addNaviBackItem(style: .black)
        setNaviTitle("About")
        
        let appIcon = UIImageView(image: .init(named: "about_appIcon"))
        appIcon.snp.makeConstraints { make in
            make.size.equalTo(114)
        }
        
        let appName = UILabel()
        appName.text = "Puff"
        appName.textColor = UIColor(white: 0.15, alpha: 1)
        appName.font = UIFont(name: YHFontName.AMB, size: 24)
        
        let version = UILabel()
        version.text = "V " + ProjGlobalInfo.currentVersion
        version.textColor = .byHexStrValue("#8C8C8C")
        version.font = UIFont(name: YHFontName.PF_SC_R, size: 18)
        
        let infoStack = UIStackView()
        infoStack.axis = .vertical
        infoStack.alignment = .center
        infoStack.addArrangedSubview(appIcon)
        infoStack.setCustomSpacing(9, after: appIcon)
        infoStack.addArrangedSubview(appName)
        infoStack.setCustomSpacing(2, after: appName)
        infoStack.addArrangedSubview(version)
        view.addSubview(infoStack)
        infoStack.snp.makeConstraints { make in
            make.top.equalTo(naviView.snp.bottom).offset(90)
            make.centerX.equalToSuperview()
        }
        
        let titleList = [
            "Terms & Conditions",
            "Privacy Policy",
            "Rate Us",
        ]
        let actionList = [
            #selector(didTouchTerms),
            #selector(didTouchPrivacy),
            #selector(didTouchReteUs),
        ]
        
        let tableStack = UIStackView()
        tableStack.axis = .vertical
        tableStack.spacing = 10
        view.addSubview(tableStack)
        tableStack.snp.makeConstraints { make in
            make.top.equalTo(infoStack.snp.bottom).offset(60)
            make.left.right.equalToSuperview().inset(16)
        }
        
        for idx in 0 ..< 3 {
            let row = AboutRowView()
            row.titleLabel.text = titleList[idx]
            row.addTarget(self, action: actionList[idx], for: .touchUpInside)
            tableStack.addArrangedSubview(row)
        }
    }
    
    @objc private func didTouchTerms() {
        UIApplication.shared.open(ProjGlobalInfo.termPageURL)
    }
    
    @objc private func didTouchPrivacy() {
        UIApplication.shared.open(ProjGlobalInfo.privacyPageURL)
    }

    @objc private func didTouchReteUs() {
        guard let scene = WindowLetValue.currentScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
}

private class AboutRowView: UIControl {
    convenience init() {
        self.init(frame: .zero)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        titleLabel.textColor = UIColor(white: 0.15, alpha: 1)
        titleLabel.font = UIFont(name: YHFontName.PF_SC_SB, size: 16)
        addSubview(titleLabel)
     
        arrowView.tintColor = .byHexStrValue("#8C8C8C")
        addSubview(arrowView)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(arrowView.snp.left).offset(-10)
        }
        
        arrowView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
    }
    
    let titleLabel = UILabel()
    let arrowView: UIView = UIImageView(image: UIImage(systemName: "chevron.right"))
}

