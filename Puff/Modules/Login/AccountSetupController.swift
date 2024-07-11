import UIKit
import SnapKit
import Toast_Swift

class AccountSetupController: YHBaseServiceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initPageView()
    }
    
    private func initPageView() {
        let bgView = UIImageView(image: UIImage(named: "lunch_background"))
        bgView.contentMode = .scaleAspectFill
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let appNameView = UIImageView(image: UIImage(named: "login_appName"))
        appNameView.contentMode = .scaleAspectFill
        view.addSubview(appNameView)
        appNameView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(240)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(startBtn)
        view.addSubview(licenseView)
        
        startBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 230, height: 54))
        }

        licenseView.snp.makeConstraints { make in
            make.top.equalTo(startBtn.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(WindowLetValue.safeAreaInsets.bottom + 55)
        }
    }
    
    private let licenseView: LicenseView = LicenseView()
    private lazy var startBtn: UIButton = {
        let startBtn = SecondSimpleBtn()
        startBtn.setTitle("Get Start", for: .normal)
        startBtn.titleLabel?.font = UIFont(name: YHFontName.Helve_Bold, size: 18)
        startBtn.addTarget(self, action: #selector(startLoginBtnDidTouch), for: .touchUpInside)
        
        var bgLayer = startBtn.bgLayer
        bgLayer.colors = [ UIColor(red: 0.44, green: 0, blue: 1, alpha: 1).cgColor,
                          UIColor(red: 0.75, green: 0, blue: 1, alpha: 1).cgColor]
        bgLayer.locations = [0, 1]
        bgLayer.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer.endPoint = CGPoint(x: 0.5, y: 1)
        // shadowCode
        startBtn.layer.shadowColor = UIColor.black.cgColor
        startBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        startBtn.layer.shadowOpacity = 0.26
        startBtn.layer.shadowRadius = 8
        return startBtn
    }()
    
    @objc private func startLoginBtnDidTouch() {
        guard licenseView.isAgreesLicense else {
            let popUp = LicenseWarningAlert()
            present(popUp, animated: true)
            popUp.didAgreeAction = { [weak self] in
                self?.licenseView.isAgreesLicense = true
                self?.startLoginIn()
            }
            return
        }
        startLoginIn()
    }
    
    private func startLoginIn() {
        guard ServerDataRequestor.testNetEnable() else {
            let err_msg = "No network, login failed, try again later."
            self.view.makeToast(err_msg)
            return
        }
        
        Task {
            do {
//                //TODO: remove after test
//                LocalValueStore.resetData()
                ToastManager.shared.style.verticalPadding = 200
                self.view.makeToastActivity(.bottom)
                ToastManager.shared.style.verticalPadding = 10
                try await AcountLaunchRunner.login()
                self.view.hideToastActivity()
                RootControllerChangeRunner.jumpToMainTabbar()
            } catch let error {
                print(#function, error)
                self.view.hideToastActivity()
                let err_msg = "No network, login failed, try again later."
                self.view.makeToast(err_msg)
            }
        }
    }
}
