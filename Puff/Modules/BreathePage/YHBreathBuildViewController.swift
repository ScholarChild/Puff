//

import UIKit
import SnapKit

class YHBreathBuildViewController: YHBaseServiceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        constructBuildPage()
    }
    
    private func constructBuildPage() {
        addPageBackground()
        view.addSubview(typeMenuView)
        typeMenuView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
        
        view.addSubview(tipBox)
        tipBox.snp.makeConstraints { make in
            make.top.equalTo(typeMenuView.snp.bottom).offset(-10)
            make.left.right.equalToSuperview().inset(16)
        }
        tipBox.setTip(by: .regular)
        
        
        let bottomSpace = WindowLetValue.safeAreaInsets.bottom + WindowLetValue.tabbarHeight
        
        view.addSubview(modeSelectView)
        modeSelectView.snp.makeConstraints { make in
//            make.top.equalTo(tipBox.snp.bottom).offset(12)
            make.centerY.equalToSuperview().offset(-bottomSpace / 2)
            make.left.right.equalToSuperview().inset(16)
        }
        
        view.insertSubview(bottomKumoView, belowSubview: modeSelectView)
        bottomKumoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(-10)
            make.bottom.equalToSuperview().inset(bottomSpace - 100)
        }
        
        view.addSubview(startBtn)
        startBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottomSpace + 23)
        }
        modeSelectView.updateChange()
    }
    
    private lazy var typeMenuView: TabbarView = {
        let view = TabbarView()
        view.delegate = self
        return view
    }()
    
    private lazy var tipBox: TipBoxView = {
        let boxView = TipBoxView()
        return boxView
    }()
    
    private lazy var modeSelectView: ModeSelectView = {
        let view = ModeSelectView()
        view.unitChangeBlock { [weak self] unit, count in
            let title = "Take \(count) \(unit)"
            self?.startBtn.setTitle(title, for: .normal)
        }
        return view
    }()
    
    private lazy var bottomKumoView: UIView = {
        let view = UIImageView(image: .init(named: "breathBuildPage_bear"))
        return view
    }()
    
    private lazy var startBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "answerBookPage_bottomBtn"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: YHFontName.Helve_Bold, size: 18)
        btn.addTarget(self, action: #selector(startNewBreath), for: .touchUpInside)
        return btn
    }()
    
    private var breathType: BreathRecord.BreathType = .regular
    @objc private func startNewBreath() {
        let breath = BreathRecord()
        breath.type = self.breathType
        breath.mode = modeSelectView.selectedMode
        breath.modeUnit = modeSelectView.selectedUnit
        BreathRecordManager.addNewCurrentUserRecord(breath)
        
        let vc = YHBreathRunViewController()
        vc.breath = breath
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension YHBreathBuildViewController: TabbarDelegate {
    fileprivate func didSelectTabbar(type: BreathRecord.BreathType) {
        tipBox.setTip(by: type)
        self.breathType = type
    }
}

private class TabbarView: UIView {
    convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = .white
        self.layer.cornerRadius = 14
        
        let stack = UIStackView()
        stack.distribution = .fillEqually
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let typeList = BreathRecord.BreathType.allCases
        for idx in 0 ..< typeList.count {
            let type = typeList[idx]
            let btn = ItemBtn()
            btn.iconView.image = type.icon
            btn.nameLabel.text = type.displayName
            
            btn.tag = idx
            btn.isSelected = (idx == 0)
            btn.addTarget(self, action: #selector(didSeletct(btn:)), for: .touchUpInside)
            stack.addArrangedSubview(btn)
            btnList.append(btn)
        }
    }
    
    private var btnList: [UIButton] = []
    weak var delegate: TabbarDelegate? = nil
    @objc private func didSeletct(btn: UIButton) {
        let index = btn.tag
        btnList.forEach({ $0.isSelected = ($0.tag == index) })
        
        let type = BreathRecord.BreathType.allCases[index]
        delegate?.didSelectTabbar(type: type)
    }
    
    private class ItemBtn: UIButton {
        convenience init() {
            self.init(frame: .zero)
            
            let stack = UIStackView(arrangedSubviews: [iconView, nameLabel])
            stack.axis = .vertical
            stack.alignment = .center
            stack.spacing = 3
            stack.isUserInteractionEnabled = false
            addSubview(stack)
            stack.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

            iconView.snp.makeConstraints { make in
                make.size.equalTo(46)
            }
            
            nameLabel.textColor = .black
            nameLabel.font = UIFont(name: YHFontName.PF_SC_SB, size: 12)
            nameLabel.textAlignment = .center
            nameLabel.snp.makeConstraints { make in
                make.height.equalTo(17)
            }
            
            addSubview(selectedCircle)
            selectedCircle.snp.makeConstraints { make in
                make.edges.equalTo(iconView)
            }
            selectedCircle.isHidden = true
            
        }
        let iconView = UIImageView()
        let selectedCircle = UIImageView(image: .init(named: "breathBuildPage_tabbar_selectedCircle"))
        let nameLabel = UILabel()
        
        override var isSelected: Bool {
            didSet { selectedCircle.isHidden = !isSelected }
        }
    }
}

private protocol TabbarDelegate: AnyObject {
    func didSelectTabbar(type: BreathRecord.BreathType)
}

private class TipBoxView: UIView {
    convenience init() {
        self.init(frame: .zero)
        backgroundView.contentMode = .scaleAspectFit
        self.addSubview(backgroundView)
        
        let contentView = UIView()
        backgroundView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        let tipText = UILabel()
        tipText.text = "TIPS"
        tipText.textColor = .byHexStrValue("#F9F9F9")
        tipText.font = UIFont(name: YHFontName.Helve_Bold, size: 16)
        contentView.addSubview(tipText)
        tipText.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(37)
        }
        
        contentView.addSubview(breathInLabel)
        breathInLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.centerY.equalTo(tipText)
        }
        
        contentView.addSubview(inHoldLabel)
        inHoldLabel.snp.makeConstraints { make in
            make.centerY.equalTo(breathInLabel)
            make.right.equalToSuperview().inset(37)
        }
        
        contentView.addSubview(breathOutLabel)
        breathOutLabel.snp.makeConstraints { make in
            make.top.equalTo(breathInLabel.snp.bottom).offset(6)
            make.left.equalTo(breathInLabel)
        }
        
        contentView.addSubview(outHoldLabel)
        outHoldLabel.snp.makeConstraints { make in
            make.right.equalTo(inHoldLabel)
            make.centerY.equalTo(breathOutLabel)
        }
        
        
        for label in [breathInLabel, inHoldLabel, breathOutLabel, outHoldLabel] {
            label.textColor = .byHexStrValue("#F9F9F9")
            label.font = UIFont(name: YHFontName.Helve_Bold, size: 14)
        }
    }
    
    let backgroundView = UIImageView()
    
    let breathInLabel = UILabel()
    let inHoldLabel = UILabel()
    let breathOutLabel = UILabel()
    let outHoldLabel = UILabel()
    
    func setTip(by type: BreathRecord.BreathType) {
        let loop = BreathLoop(type: type)
        breathInLabel.text = "Breathe in \(loop.breatheIn)s"
        inHoldLabel.text = "Hold \(loop.inHold)s"
        breathOutLabel.text = "Breathe out \(loop.breatheOut)s"
        outHoldLabel.text = "Hold \(loop.outHold)s"
        
        let insetSpace = (WindowLetValue.windowWidth - 16 * 2) / 6 - 44
        
        switch type {
            case .regular:
                backgroundView.image = UIImage(named: "breathBuildPage_tipBoxBackground_left")
                backgroundView.snp.remakeConstraints { make in
                    make.left.equalToSuperview().inset(insetSpace)
                }
            case .deStress:
                backgroundView.image = UIImage(named: "breathBuildPage_tipBoxBackground_center")
                backgroundView.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                }
            case .relax:
                backgroundView.image = UIImage(named: "breathBuildPage_tipBoxBackground_right")
                backgroundView.snp.remakeConstraints { make in
                    make.right.equalToSuperview().inset(insetSpace)
                }
        }
        
        backgroundView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
    }
}

private class ModeSelectView: UIView {
    convenience init() {
        self.init(frame: .zero)
        let bgView = UIImageView(image: UIImage(named: "breathBuildPage_modeSelect_background"))
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let btnContentView = UIView()
        btnContentView.layer.cornerRadius = 26 / 2
        btnContentView.backgroundColor = .byHexStrValue("#6C89FC")
        addSubview(btnContentView)
        btnContentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        btnIndicator.backgroundColor = .white
        btnIndicator.layer.cornerRadius = 26 / 2
        btnContentView.addSubview(btnIndicator)
        btnIndicator.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 84, height: 26))
        }
        
        let btnStack = UIStackView()
        btnStack.distribution = .fillEqually
        btnContentView.addSubview(btnStack)
        btnStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let titleList = ["Breaths", "Minutes"]
        for idx in 0 ..< 2 {
            let btn = UIButton()
            btn.setTitle(titleList[idx], for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.setTitleColor(.byHexStrValue("#272727"), for: .selected)
            btn.titleLabel?.font = UIFont(name: YHFontName.Helve_Bold, size: 16)
            btn.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 84, height: 26))
            }
            btn.tag = idx
            btn.isSelected = (idx == 0)
            btn.addTarget(self, action: #selector(didTouch(btn:)), for: .touchUpInside)
            btnStack.addArrangedSubview(btn)
            btnList.append(btn)
        }
        
        addSubview(unitPicker)
        unitPicker.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(24)
        }
        unitPicker.currentUnitDidChange = { [weak self] unit in
            self?.updateChange()
        }
    }
    private var btnList: [UIButton] = []
    private let btnIndicator = UIView()
    override func layoutSubviews() {
        super.layoutSubviews()
        let selectedBtn = btnList.first(where: { $0.isSelected })!
        btnIndicator.frame = selectedBtn.frame
    }
    
    var selectedMode: BreathRecord.LoopMode = .breathsCount
    var selectedModeName = "Breaths"
    @objc private func didTouch(btn: UIButton) {
        btnList.forEach({ $0.isSelected = ($0.tag == btn.tag) })
        setNeedsLayout()
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        let typeList: [BreathRecord.LoopMode] = [.breathsCount, .minutes]
        let nameList = ["Breaths", "Minutes"]
        selectedMode = typeList[btn.tag]
        selectedModeName = nameList[btn.tag]
        updateChange()
    }
    
    private let unitPicker = YHBreathBuildViewController.BreathUnitSelectCountView()
    var selectedUnit: Int {
        unitPicker.currentUnit
    }
    
    private var selectDidChange: (_ unit: String, _ count: Int) -> Void = { _, _ in }
    func unitChangeBlock(block: @escaping (_ unit: String, _ count: Int) -> Void) {
        selectDidChange = block
    }
    
    func updateChange() {
        selectDidChange(selectedModeName, unitPicker.currentUnit)
    }
}
