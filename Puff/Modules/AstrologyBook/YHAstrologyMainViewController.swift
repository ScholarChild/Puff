//

import UIKit
import SnapKit

class YHAstrologyMainViewController: YHBaseServiceViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        constructBookMainPage()
        loadSentense()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSentenceBackground()
    }
    
    private func constructBookMainPage() {
        addPageBackground()
        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(WindowLetValue.safeAreaInsets.bottom + WindowLetValue.tabbarHeight)
        }
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 20
        scroll.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(16)
            make.left.right.equalTo(self.view).inset(16)
        }
        
        contentStack.addArrangedSubview(sentenceBoxView)
        sentenceBoxView.snp.makeConstraints { make in
            let height = ceil((WindowLetValue.windowWidth - 16 * 2) * 1.2973)
            make.height.equalTo(height)
        }
        
        contentStack.addArrangedSubview(editSentenceBackgroundView)
        
        contentStack.addArrangedSubview(answerBookBtn)
        answerBookBtn.snp.makeConstraints { make in
            let height = ceil((WindowLetValue.windowWidth - 16 * 2) * 0.603)
            make.height.equalTo(height)
        }
        
        editSentenceBackgroundView.isHidden = true
        answerBookBtn.isHidden = false
    }
    
    private lazy var sentenceBoxView: SentenceContentView = {
        let view = SentenceContentView()
        view.snapshootBtn.addTarget(self, action: #selector(saveSentenceSnapShoot), for: .touchUpInside)
        view.changeBgBtn.addTarget(self, action: #selector(switchBackgroundListShow), for: .touchUpInside)
        return view
    }()
    
    private lazy var editSentenceBackgroundView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 136, height: 176)
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .horizontal
        
        let contentView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        contentView.backgroundColor = .clear
        contentView.delegate = self
        contentView.dataSource = self
        contentView.register(BackgroundCell.self, forCellWithReuseIdentifier: cellIdent)
        contentView.snp.makeConstraints { make in
            make.height.equalTo(176)
        }
        
        return contentView
    }()
    
    private lazy var answerBookBtn: UIView = {
        let contentView = UIButton()
        contentView.setBackgroundImage(UIImage(named: "astrologyMainPage_answerBookBtn"), for: .normal)
        contentView.addTarget(self, action: #selector(openAnswerBook), for: .touchUpInside)
        return contentView
    }()
    
    private func loadSentense() {
        let sentence = AstrologyManager.getTodaySentence()
        sentenceBoxView.sentenseLabel.text = sentence.quote
        sentenceBoxView.authorLabel.text = sentence.author
    }
    
    private func updateSentenceBackground() {
        let imageName = AstrologyManager.selectedBackground.imageName
        sentenceBoxView.backgroundImageView.image = UIImage(named: imageName)
    }
    
    @objc private func saveSentenceSnapShoot() {
        let view = self.sentenceBoxView.backgroundImageView
        guard let image = view.toImage() else { 
            self.view.makeToast("save failure", position: .center)
            return
        }
        image.saveToPhotosAlbum { [weak self] isSuccess, error in
            if isSuccess {
                self?.view.makeToast("save success", position: .center)
            }else if let error = error {
                self?.view.makeToast("Failed to save, \(error.localizedDescription)", position: .center)
            }
        }
    }
    
    @objc private func switchBackgroundListShow() {
        editSentenceBackgroundView.isHidden.toggle()
        answerBookBtn.isHidden.toggle()
        if editSentenceBackgroundView.isHidden == false {
            reloadBackgroundList()
        }
    }
    
    private func reloadBackgroundList() {
        backgrounList = AstrologyManager.backgroundList()
        editSentenceBackgroundView.reloadData()
    }
    
    private let cellIdent = "backgroundCell"
    private var backgrounList = AstrologyManager.backgroundList()
    
    @objc private func openAnswerBook() {
        print(#function)
        let vc = YHAnswerBookViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension YHAstrologyMainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgrounList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdent, for: indexPath) as! BackgroundCell
        cell.image.image = UIImage(named: backgrounList[indexPath.row].imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AstrologyManager.selectedBackground = backgrounList[indexPath.row]
        updateSentenceBackground()
    }
}

private class SentenceContentView: UIView {
    convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = UIColor(white: 0.85, alpha: 1)
        self.layer.cornerRadius = 16
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 6, height: 2)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 20
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.cornerRadius = 16
        backgroundImageView.clipsToBounds = true
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor(white: 0, alpha: 0.13)
        shadowView.layer.cornerRadius = 16
        backgroundImageView.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sentenseLabel.textColor = .white
        sentenseLabel.font = UIFont(name: YHFontName.Helve_Bold, size: 24)
        sentenseLabel.numberOfLines = 0
        backgroundImageView.addSubview(sentenseLabel)
        sentenseLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(110)
            make.left.right.equalToSuperview().inset(34)
        }
        
        authorLabel.textColor = .white
        authorLabel.textAlignment = .right
        authorLabel.font = UIFont(name: YHFontName.Helve_Bold, size: 24)
        backgroundImageView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(sentenseLabel.snp.bottom).offset(45)
            make.right.equalTo(sentenseLabel)
            make.left.greaterThanOrEqualTo(sentenseLabel)
        }
        
        snapshootBtn.setImage(UIImage(named: "astrologyMainPage_snapshoot"), for: .normal)
        addSubview(snapshootBtn)
        snapshootBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(11)
            make.bottom.equalToSuperview().inset(17)
        }
        
        changeBgBtn.setImage(UIImage(named: "astrologyMainPage_changeBackground"), for: .normal)
        addSubview(changeBgBtn)
        changeBgBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(11)
            make.bottom.equalToSuperview().inset(17)
        }
    }
    
    let backgroundImageView = UIImageView()
    let sentenseLabel = UILabel()
    let authorLabel = UILabel()
    
    let snapshootBtn = UIButton()
    let changeBgBtn = UIButton()
}

private class BackgroundCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 9
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let image = UIImageView()
}
