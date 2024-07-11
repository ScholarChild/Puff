//

import UIKit

class YHBreathRunViewController: YHBaseServiceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        constructRunPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runBreathPractice()
    }
    
    private func constructRunPage() {
        addPageBackground()
        
        view.addSubview(bottomBearView)
        updateBearStatus(.hold)
        bottomBearView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(-10)
            make.bottom.equalToSuperview().offset(50)
        }
        
        view.addSubview(bottomBtnContentView)
        bottomBtnContentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(60)
        }
        for statucContentView in [runStatusContentView, completeStatusContentView] {
            view.addSubview(statucContentView)
            statucContentView.snp.makeConstraints { make in
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.left.right.equalToSuperview().inset(16)
                make.bottom.equalTo(bottomBearView.snp.top)
            }
        }
        
        showRunStatusPage()
    }
    
    private lazy var runStatusContentView: UIView = {
        let contentView = UIView()
        
        let commonBackBtn = UIButton()
        commonBackBtn.setImage(UIImage(named: "breathRunPage_commonBackBtn"), for: .normal)
        commonBackBtn.titleLabel?.font = UIFont(name: YHFontName.Helve_Bold, size: 18)
        commonBackBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        contentView.addSubview(commonBackBtn)
        commonBackBtn.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
        }
        
        let typeLabel = UILabel()
        typeLabel.text = breath.type.displayName
        typeLabel.textColor = .white
        typeLabel.font = UIFont(name: YHFontName.Helve_Bold, size: 24)
        contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        contentView.addSubview(countDownLabel)
        countDownLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(22)
            make.left.equalToSuperview()
        }
        
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return contentView
    }()
    
    private lazy var countDownLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: YHFontName.Helve_Regular, size: 20)
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: YHFontName.Helve_Bold, size: 36)
        label.numberOfLines = 2
        return label
    }()
    
    private func setStatusText(status: BreatheStatus, delay: Int) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 22
        let statusName: String
        switch status {
            case .hold:
                statusName = "Hold"
            case .breathIn:
                statusName = "Breathe In"
            case .breathOut:
                statusName = "Breathe Out"
        }
        let text = [statusName, "\(delay)s"].joined(separator: "\n")
        let attr = NSAttributedString(string: text, attributes: [
            .paragraphStyle: style
        ])
        DispatchQueue.main.async {
            self.statusLabel.attributedText = attr
            self.statusLabel.textAlignment = .center
        }
    }
    
    private lazy var completeStatusContentView: UIView = {
        let icon = UIImageView(image: .init(named: "breathRunPage_completeIcon"))
        let finishMessage = UILabel()
        finishMessage.text = "Great job! You have completed one breathing exercise"
        finishMessage.textAlignment = .center
        finishMessage.numberOfLines = 0
        finishMessage.textColor = .white
        finishMessage.font = UIFont(name: YHFontName.Helve_Bold, size: 26)
        
        let contentView = UIView()
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(finishMessage)
        finishMessage.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom)
            make.width.equalTo(323)
            make.left.right.bottom.equalToSuperview()
        }
        
        let boxView = UIView()
        boxView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return boxView
    }()
    
    private lazy var bottomBearView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var bottomBtnContentView: UIView = {
        let contentView = UIStackView()
        contentView.spacing = 22
        contentView.addArrangedSubview(finishBackBtn)
        contentView.addArrangedSubview(retryBtn)
        return contentView
    }()
    
    private lazy var finishBackBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .byHexStrValue("#E5E5E5")
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.26).cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowOpacity = 1
        btn.layer.shadowRadius = 8
        btn.layer.cornerRadius = 46 / 2
        
        btn.setTitle("Back", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: YHFontName.Helve_Bold, size: 18)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        btn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 124, height: 46))
        }
        return btn
    }()
    
    private lazy var retryBtn: UIButton = {
        let btn = UIButton()
        
        let bgLayer = CAGradientLayer()
        bgLayer.colors = [UIColor(red: 1, green: 0.74, blue: 0.91, alpha: 1).cgColor,
                           UIColor(red: 0.44, green: 0, blue: 1, alpha: 1).cgColor,
                           UIColor(red: 0.75, green: 0, blue: 1, alpha: 1).cgColor]
        bgLayer.locations = [0, 0, 1]
        bgLayer.frame = CGRect(x: 0, y: 0, width: 124, height: 46)
        bgLayer.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer.endPoint = CGPoint(x: 0.5, y: 1)
        bgLayer.cornerRadius = 46 / 2
        bgLayer.masksToBounds = true
        
        btn.layer.addSublayer(bgLayer)
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.26).cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowOpacity = 1
        btn.layer.shadowRadius = 8
        btn.layer.cornerRadius = 46 / 2
        btn.setTitle("Again", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: YHFontName.Helve_Bold, size: 18)
        btn.addTarget(self, action: #selector(didTouchAgain), for: .touchUpInside)
        btn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 124, height: 46))
        }
        return btn
    }()
    
    enum BreatheStatus {
        case hold
        case breathIn
        case breathOut
    }
    
    private func updateBearStatus(_ status: BreatheStatus) {
        let image: UIImage
        switch status {
            case .hold:
                image = UIImage(named: "breathRunPage_bear_holdIn")!
            case .breathIn:
                image = UIImage(named: "breathRunPage_bear_breathIn")!
            case .breathOut:
                image = UIImage(named: "breathRunPage_bear_breathOut")!
        }
        DispatchQueue.main.async {
            self.bottomBearView.image = image
        }
    }
    
    lazy var breath = BreathRecord()
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTouchAgain() {
        runBreathPractice()
    }
    
    private func runBreathPractice() {
        showRunStatusPage()
        startTimeCountDownIfNeed()
        startBreatheLoop()
    }
    
    private var countDownloadFinish = false
    private func startTimeCountDownIfNeed() {
        countDownloadFinish = false
        guard breath.mode == .minutes else {
            countDownloadFinish = true
            return
        }
        Task {
            var duration = self.breath.modeUnit * 60
            while duration > 0 {
                let minutes = duration / 60
                let second = duration % 60
                DispatchQueue.main.async {
                    self.countDownLabel.text = String(format: "%02d:%02d", minutes, second)
                }
                let delay = 1
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                duration -= delay
            }
            self.countDownloadFinish = true
            self.showCompletePageIfNeed()
        }
    }
    private var breathLoopFinish = false
    private func startBreatheLoop() {
        breathLoopFinish = false
        Task {
            let loop = BreathLoop(type: self.breath.type)
            var duration = 0
            var breatheCount = 0
            switch self.breath.mode {
                case .breathsCount:
                    duration = self.breath.modeUnit * loop.loopTime
                    breatheCount = self.breath.modeUnit
                case .minutes:
                    duration = self.breath.modeUnit * 60
                    breatheCount = Int(ceil(Float(duration) / Float(loop.loopTime)))
            }
            
            @MainActor func setup(status: BreatheStatus, delay: Int) async throws {
                self.updateBearStatus(status)
                self.setStatusText(status: status, delay: delay)
                if self.breath.mode == .breathsCount {
                    DispatchQueue.main.async {
                        self.countDownLabel.text = "\(breatheCount) breaths"
                    }
                }
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                duration -= delay
            }
            while duration > 0 {
                try await setup(status: .breathIn, delay: loop.breatheIn)
                try await setup(status: .hold, delay: loop.inHold)
                try await setup(status: .breathOut, delay: loop.breatheOut)
                try await setup(status: .hold, delay: loop.outHold)
                breatheCount -= 1
            }
            self.breathLoopFinish = true
            self.showCompletePageIfNeed()
        }
    }
    
    private func showRunStatusPage() {
        runStatusContentView.isHidden = false
        completeStatusContentView.isHidden = true
        bottomBtnContentView.isHidden = true
    }
    
    private func showCompletePageIfNeed() {
        guard countDownloadFinish && breathLoopFinish else { return }
        runStatusContentView.isHidden = true
        completeStatusContentView.isHidden = false
        bottomBtnContentView.isHidden = false
    }
}
