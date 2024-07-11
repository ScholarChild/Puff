import UIKit
import SnapKit
import Kingfisher

class YHCurrentUserInfoCollectionPage: YHBaseServiceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        buildPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    private func buildPage() {
        addPageBackground()
        naviView.setRightItem(view: userEditBtn, inset: 0)
        
        let pageScroll = UIScrollView()
        view.addSubview(pageScroll)
        pageScroll.snp.makeConstraints { make in
            make.top.equalTo(naviView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(WindowLetValue.safeAreaInsets.bottom + WindowLetValue.tabbarHeight)
        }
        
        let pageContainer = UIView()
        pageScroll.addSubview(pageContainer)
        pageContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.left.right.equalTo(self.view).inset(16)
        }
        
        pageContainer.addSubview(headBgView)
        headBgView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview()
        }
        
        headBgView.addSubview(headPortialView)
        headPortialView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        let nameStack = UIStackView(arrangedSubviews: [nameLabel, identLabel])
        nameStack.axis = .vertical
        nameStack.alignment = .leading
        nameStack.spacing = 2
        pageContainer.addSubview(nameStack)
        nameStack.snp.makeConstraints { make in
            make.left.equalTo(headBgView.snp.right).offset(16)
            make.right.lessThanOrEqualToSuperview()
            make.centerY.equalTo(headPortialView)
        }
        
        let todayTitleLabel = label(title: "Number of breaths per day")
        pageContainer.addSubview(todayTitleLabel)
        todayTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headBgView.snp.bottom).offset(22)
            make.left.right.equalToSuperview()
        }
        
        let typeList = BreathRecord.BreathType.allCases
        let todayStack = UIStackView()
        todayStack.distribution = .fillEqually
        todayStack.spacing = 11
        pageContainer.addSubview(todayStack)
        todayStack.snp.makeConstraints { make in
            make.top.equalTo(todayTitleLabel.snp.bottom).offset(13)
            make.left.right.equalToSuperview()
        }
        
        for type in typeList {
            let box = TodayBreathBox()
            box.iconView.image = type.icon
            box.typeLabel.text = type.displayName
            box.countLabel.text = "0"
            todayStack.addArrangedSubview(box)
            todayBoxList.append(box)
        }
        
        let totalTitleLabel = label(title: "Total number of breaths")
        pageContainer.addSubview(totalTitleLabel)
        totalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(todayStack.snp.bottom).offset(22)
            make.left.right.equalToSuperview()
        }
        
        let totalStack = UIStackView()
        totalStack.spacing = 10
        totalStack.axis = .vertical
        pageContainer.addSubview(totalStack)
        totalStack.snp.makeConstraints { make in
            make.top.equalTo(totalTitleLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview()
        }
        
        for type in typeList {
            let box = TotalBreathBox()
            box.iconView.image = type.icon
            box.typeLabel.text = type.displayName
            box.countLabel.text = "1"
            totalStack.addArrangedSubview(box)
            totalBoxList.append(box)
        }
        
        let settingTitle = label(title: "Other")
        pageContainer.addSubview(settingTitle)
        settingTitle.snp.makeConstraints { make in
            make.top.equalTo(totalStack.snp.bottom).offset(22)
            make.left.right.equalToSuperview()
        }
        
        pageContainer.addSubview(settingContentView)
        settingContentView.snp.makeConstraints { make in
            make.top.equalTo(settingTitle.snp.bottom).offset(13)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private lazy var userEditBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "personal_navi_userEdit"), for: .normal)
        btn.addTarget(self, action: #selector(openUserEditPage), for: .touchUpInside)
        btn.contentEdgeInsets = UIEdgeInsets(allEdge: 16)
        return btn
    }()
    
    private lazy var headPortialView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        imgView.layer.cornerRadius = 60 / 2
        imgView.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        return imgView
    }()
    
    private lazy var headBgView: UIView = {
        let view = RanbowColorView()
        view.isSetCornerByHeight = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: YHFontName.PF_SC_SB, size: 20)
        return label
    }()
    
    private lazy var identLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: YHFontName.PF_SC_SB, size: 14)
        return label
    }()
    
    private func label(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont(name: YHFontName.Helve_Bold, size: 20)
        return label
    }
    
    private var todayBoxList: [TodayBreathBox] = []
    private var totalBoxList: [TotalBreathBox] = []

    private func updateData() {
        let user = UserManager.currentUser
        headPortialView.kf.setImage(with: user.avatar.thumbURL)
        nameLabel.text = user.nickName
        identLabel.text = "ID: " + LocalValueStore.userIdent
        
        let typeList = BreathRecord.BreathType.allCases
        for idx in 0 ..< typeList.count {
            let type = typeList[idx]
            let todayBox = todayBoxList[idx]
            todayBox.countLabel.text = String(BreathRecordManager.todayRecordCount(of: type))
            let totalBox = totalBoxList[idx]
            totalBox.countLabel.text = String(BreathRecordManager.totalRecordCount(of: type))
        }
    }
    
    private lazy var settingContentView: UIView = {
        let iconNameList = [
            "personal_settingBoxIcon_about",
            "personal_settingBoxIcon_logout",
            "personal_settingBoxIcon_deleteAccount",
        ]
        
        let titleList = [
            "About",
            "Log out",
            "Delete Account",
        ]
        
        let actionList = [
            #selector(jumpToAboutPage),
            #selector(logoutAccount),
            #selector(deleteAccount)
        ]
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 10
        for row in 0 ..< 2 {
            let rowStack = UIStackView()
            rowStack.distribution = .fillEqually
            rowStack.spacing = 10
            contentStack.addArrangedSubview(rowStack)
            for col in 0 ..< 2 {
                let idx = row * 2 + col
                if idx < titleList.count {
                    let box = SettingBox()
                    box.iconView.image = UIImage(named: iconNameList[idx])
                    box.nameLabel.text = titleList[idx]
                    box.addTarget(self, action: actionList[idx], for: .touchUpInside)
                    rowStack.addArrangedSubview(box)
                }else {
                    rowStack.addArrangedSubview(UIView())
                }
            }
        }
        return contentStack
    }()
    
    
    @objc private func openUserEditPage() {
        let vc = ProfileEditPage()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func jumpToAboutPage() {
        let vc = ProjGlobalAboutPage()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func deleteAccount() {
        let alert = YHBaseOperationAlert()
        alert.msg = "Are you sure you want to delete your account?"
        alert.leftTitle = "Yes"
        alert.rightTitle = "No"
        present(alert, animated: true)
        alert.leftBtnAction = { [weak self] in
            guard let self = self else { return }
            let errMsg = "No network, account deletion failed, try again later."
            YHMockNetworkRunner.request(on: self, err_msg: errMsg) {
                AcountLaunchRunner.deleteCurrentUser()
                RootControllerChangeRunner.jumpToAccountLoginPage()
            }
        }
    }
    
    @objc private func logoutAccount() {
        let alert = YHBaseOperationAlert()
        alert.msg = "Are you sure you want to log out?"
        alert.leftTitle = "Yes"
        alert.rightTitle = "No"
        present(alert, animated: true)
        alert.leftBtnAction = { [weak self] in
            guard let self = self else { return }
            let errMsg = "No network, logout failed, try again later."
            YHMockNetworkRunner.request(on: self, err_msg: errMsg) {
                AcountLaunchRunner.logoutCurrentUser()
                RootControllerChangeRunner.jumpToAccountLoginPage()
            }
        }
    }
}

private class TodayBreathBox: UIView {
    convenience init() {
        self.init(frame: .zero)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        
        iconView.contentMode = .scaleAspectFit
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.size.equalTo(46)
            make.top.equalToSuperview().inset(11)
            make.centerX.equalToSuperview()
        }
        
        typeLabel.textColor = UIColor(white: 0.15, alpha: 1)
        typeLabel.font = UIFont(name: YHFontName.PF_SC_SB, size: 14)
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        countLabel.textColor = UIColor(white: 0.15, alpha: 1)
        countLabel.font = UIFont(name: YHFontName.PF_SC_SB, size: 36)
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel).offset(15)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        unitLabel.textColor = UIColor(white: 0.15, alpha: 1)
        unitLabel.font = UIFont(name: YHFontName.Helve_Oblique, size: 14)
        unitLabel.text = "rounds"
        addSubview(unitLabel)
        unitLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(countLabel).offset(43)
            make.height.equalTo(17)
            make.bottom.equalToSuperview().inset(7)
        }
    }
    
    let iconView = UIImageView()
    let typeLabel = UILabel()
    let countLabel = UILabel()
    let unitLabel = UILabel()
}

private class TotalBreathBox: UIView {
    convenience init() {
        self.init(frame: .zero)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        iconView.contentMode = .scaleAspectFit
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.top.bottom.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(14)
        }
        
        typeLabel.textColor = UIColor(white: 0.15, alpha: 1)
        typeLabel.font = UIFont(name: YHFontName.PF_SC_SB, size: 14)
        addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        countLabel.textColor = UIColor(white: 0.15, alpha: 1)
        countLabel.font = UIFont(name: YHFontName.PF_SC_SB, size: 14)
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(typeLabel.snp.right).offset(10)
            make.right.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
    }
    
    let iconView = UIImageView()
    let typeLabel = UILabel()
    let countLabel = UILabel()
}

private class SettingBox: UIControl {
    convenience init() {
        self.init(frame: .zero)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        iconView.contentMode = .scaleAspectFit
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.bottom.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(14)
        }
        
        nameLabel.textColor = UIColor(white: 0.15, alpha: 1)
        nameLabel.font = UIFont(name: YHFontName.PF_SC_SB, size: 14)
        nameLabel.textAlignment = .center
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(14)
        }
    }
    
    let iconView = UIImageView()
    let nameLabel = UILabel()
}
