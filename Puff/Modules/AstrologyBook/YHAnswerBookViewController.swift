//

import UIKit

class YHAnswerBookViewController: YHBaseServiceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        constructBookPage()
    }
    
    private func constructBookPage() {
        addPageBackground()
        addNaviBackItem(style: .white)
        setNaviTitle("The Book of Answers")
        
        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.snp.makeConstraints { make in
            make.top.equalTo(naviView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        let pageContentView = UIView()
        scroll.addSubview(pageContentView)
        pageContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.left.right.equalTo(self.view)
        }
        
        pageContentView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(48)
        }
        
        let coverImageView = UIImageView()
        coverImageView.image = UIImage(named: "answerBookPage_bookCover")
        pageContentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(tipLabel.snp.bottom).offset(10)
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.667)
        }
        
        coverImageView.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(128)
        }
        
        coverImageView.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(64)
        }
        
        let btnStack = UIStackView(arrangedSubviews: [getAnswerBtn, backBtn, retryBtn])
        btnStack.spacing = 22
        backBtn.isHidden = true
        retryBtn.isHidden = true
        pageContentView.addSubview(btnStack)
        btnStack.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(WindowLetValue.safeAreaInsets.bottom + 20)
        }
    }
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.text = "Say your question silently for 3 seconds"
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: YHFontName.Helve_Regular, size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let centerView = UIImageView(image: .init(named: "answerBookPage_magicCircle"))

    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: YHFontName.PF_SC_SB, size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var getAnswerBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "answerBookPage_bottomBtn"), for: .normal)
        btn.setTitle("Get answers", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: YHFontName.Helve_Bold, size: 18)
        btn.addTarget(self, action: #selector(getAnswer), for: .touchUpInside)
        return btn
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.26).cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowOpacity = 1
        btn.layer.shadowRadius = 8
        btn.layer.cornerRadius = 46 / 2
        
        btn.setTitle("Back", for: .normal)
        btn.setTitleColor(UIColor(white: 0.22, alpha: 1), for: .normal)
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
        btn.setTitle("Ask again", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: YHFontName.Helve_Bold, size: 18)
        btn.addTarget(self, action: #selector(getAnswer), for: .touchUpInside)
        btn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 124, height: 46))
        }
        return btn
    }()
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func getAnswer(_ btn: UIButton) {
        btn.isUserInteractionEnabled = false
        
        answerLabel.text = AstrologyManager.getAnswerByBook()
        startAnimation {
            btn.isUserInteractionEnabled = true
            self.getAnswerBtn.isHidden = true
            self.retryBtn.isHidden = false
            self.backBtn.isHidden = false
        }
    }
    
    func startAnimation(afterAction: @escaping () -> Void) {
        centerView.alpha = 1
        centerView.transform = .identity
        answerLabel.alpha = 0
        answerLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveLinear], animations: {
            self.centerView.transform = CGAffineTransform(rotationAngle: .pi)
        }) { _ in
            UIView.animate(withDuration: 0.7, delay: 0, options: [.curveLinear], animations: {
                self.centerView.transform = .identity
            }) { _ in
                UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
                    self.centerView.alpha = 0
                    self.centerView.transform = CGAffineTransform(rotationAngle: .pi)
                    
                    self.answerLabel.transform = .identity
                    self.answerLabel.alpha = 1
                }) { _ in
                    afterAction()
                }
            }
        }
    }
}
