import UIKit
import SnapKit
import Kingfisher
import HXPhotoPicker

class ProfileEditPage: YHBaseServiceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addPageBackground()
        addNaviBackItem()
        setNaviTitle("Edit Profile")
        
        let headbgView = RanbowColorView()
        headbgView.isSetCornerByHeight = true
        view.addSubview(headbgView)
        headbgView.snp.makeConstraints { make in
            make.top.equalTo(naviView.snp.bottom).offset(60)
            make.size.equalTo(98)
            make.centerX.equalToSuperview()
        }
        
        headPortraitView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        headPortraitView.contentMode = .scaleAspectFill
        headPortraitView.layer.cornerRadius = 92 / 2
        headPortraitView.clipsToBounds = true
        headPortraitView.isUserInteractionEnabled = true
        headPortraitView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarViewDidTouch)))
        headbgView.addSubview(headPortraitView)
        headPortraitView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
        
        let cameraIcon = UIImageView(image: UIImage(named: "userEdit_avatar_camera"))
        view.addSubview(cameraIcon)
        cameraIcon.snp.makeConstraints { make in
            make.centerX.equalTo(headPortraitView)
            make.centerY.equalTo(headPortraitView.snp.bottom)
        }
        
        view.addSubview(identContentView)
        identContentView.snp.makeConstraints { make in
            make.top.equalTo(headbgView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        view.addSubview(nameContentView)
        nameContentView.snp.makeConstraints { make in
            make.top.equalTo(identContentView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        let finishBtn = SecondSimpleBtn()
        finishBtn.setFontSize(20)
        finishBtn.setTitle("Done", for: .normal)
        finishBtn.addTarget(self, action: #selector(finishBtnDidTouch), for: .touchUpInside)
        view.addSubview(finishBtn)
        finishBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 230, height: 54))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private let nameTF = UITextField()
    private lazy var nameContentView: UIView = {
        let contentView = UIView()
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        
        nameTF.textColor = UIColor(white: 0.55, alpha: 1)
        nameTF.font = UIFont(name: YHFontName.PF_SC_SB, size: 14)
        nameTF.textAlignment = .right
        contentView.addSubview(nameTF)
        nameTF.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(14)
            make.top.bottom.equalToSuperview()
        }
        
        let leftLabel = UILabel()
        leftLabel.textColor = UIColor(white: 0.15, alpha: 1)
        leftLabel.font = UIFont(name: YHFontName.PF_SC_SB, size: 16)
        leftLabel.text = "Nick Name  "
        nameTF.leftView = leftLabel
        nameTF.leftViewMode = .always
        return contentView
    }()
    
    private let identLabel = UILabel()
    private lazy var identContentView: UIView = {
        let contentView = UIControl()
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        contentView.addTarget(self, action: #selector(copyIdent), for: .touchUpInside)
        
        identLabel.textColor = UIColor(white: 0.15, alpha: 1)
        identLabel.font = UIFont(name: YHFontName.PF_SC_SB, size: 16)
        contentView.addSubview(identLabel)
        identLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(14)
        }

        let copyLabel = UILabel()
        copyLabel.textColor = .byHexStrValue("#349DFE")
        copyLabel.font = UIFont(name: YHFontName.PF_SC_SB, size: 14)
        copyLabel.textAlignment = .right
        copyLabel.text = "copy"
        contentView.addSubview(copyLabel)
        copyLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(identLabel.snp.right).offset(10)
            make.right.equalToSuperview().inset(14)
            make.top.bottom.equalToSuperview()
        }
        return contentView
    }()
    
    private func loadData() {
        let user = UserManager.currentUser
        headPortraitView.kf.setImage(with: user.avatar.thumbURL)
        nameTF.text = user.nickName
        identLabel.text = "ID: " + LocalValueStore.userIdent
    }
    
    private func saveData() {
        let user = UserManager.currentUser
        if let url = headURL {
            user.avatar = .init(localURL: url, type: .photo)
        }
        if let name = nameTF.text, name.count > 0 {
            user.nickName = name
        }
        UserManager.saveCurrentUser()
    }
    
    private let headPortraitView = UIImageView()
    @objc private func avatarViewDidTouch() {
        self.view.endEditing(true)
        openPhotoLib { [weak self] url in
            guard let self = self else { return }
            self.headPortraitView.kf.setImage(with: url)
            self.headURL = url
        }
    }
    
    private var headURL: URL? = nil
    private func openPhotoLib(complete: @escaping (_ url: URL) -> Void) {
        Task.init {
            do {
                if AssetManager.authorizationStatus() == .denied {
                    let deny_msg = "​Unable to access your photo library to change profile avatar. Please go to your phone settings to enable photo album permissions.​​"
                    self.view.makeToast(deny_msg, duration: 3)
                    return
                }
                
                var config = PickerConfiguration.default
                config.selectOptions = [.photo]
                config.selectMode = .single
                
                let urls: [URL] = try await Photo.picker(config)
                if let url = urls.first {
                    complete(url)
                }
            } catch PickerError.canceled {
                print("user cancel")
            } catch let error {
                print(type(of: error))
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func copyIdent() {
        let ident = LocalValueStore.userIdent
        print(ident)
        UIPasteboard.general.string = ident
    }
    
    @objc private func finishBtnDidTouch() {
        self.view.endEditing(true)
        let err_msg = "No network, profile editing failed, try again later."
        YHMockNetworkRunner.request(on: self, err_msg: err_msg) { [weak self] in
            self?.saveData()
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

