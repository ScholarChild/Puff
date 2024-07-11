//

import UIKit
import SnapKit

extension YHBreathBuildViewController {
    class BreathUnitSelectCountView: UIView {
        convenience init() {
            self.init(frame: .zero)
            let layout = CustomLayout()
            
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(SimpleLabelCell.self, forCellWithReuseIdentifier: cellIdent)
            addSubview(collectionView)
            collectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(layout.itemSize.height)
            }
            
            addSubview(indicator)
            sendSubviewToBack(indicator)
            indicator.snp.makeConstraints { make in
                make.centerX.top.bottom.equalToSuperview()
                make.width.equalTo(38)
            }
            
            numberList = (1 ... 50).map({ "\($0)" })
            numberList.insert(contentsOf: Array(repeating: "", count: 3), at: 0)
            numberList.append(contentsOf: Array(repeating: "", count: 3))
            collectionView.reloadData()
            
            self.currentUnit = 50 / 2
            Task {
                let delay = 0.1
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                DispatchQueue.main.async {
                    let defaultIdx = 50 / 2 + 3 - 1
                    self.collectionView.scrollToItem(at: .init(row: defaultIdx, section: 0),
                                                     at: .centeredHorizontally, animated: false)
                }
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                DispatchQueue.main.async {
                    self.updateCellColors()
                }
            }
        }
        
        private var collectionView: UICollectionView!
        private let indicator = IndicatorView()
        
        private let cellIdent = "numberCell"
        private var numberList: [String] = []
        var currentUnit: Int = 1
        var currentUnitDidChange: (_ unit: Int) -> Void = { _ in }
        
    }
}

extension YHBreathBuildViewController.BreathUnitSelectCountView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdent, for: indexPath) as!
        SimpleLabelCell
        cell.label.text = numberList[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCellColors()
    }
    
    private func updateCellColors() {
        for cell in collectionView.visibleCells.compactMap({ $0 as? SimpleLabelCell }) {
            let label = cell.label
            let cellCenterX = self.collectionView.convert(cell.center, to: self).x
            let contentCenterX = self.bounds.midX
            let centerDistant = abs(cellCenterX - contentCenterX)
            let itemWidth = cell.bounds.width
            if centerDistant < itemWidth / 2 {
                label.textColor = .white
            }else {
                label.textColor = UIColor(white: 0.22, alpha: 1)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        currentUnit = Int(round(offsetX * 7 / collectionView.frame.width)) + 1
        currentUnitDidChange(currentUnit)
    }
}

private class CustomLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        let winWidth = WindowLetValue.windowWidth
        let contentWidth = winWidth - 16 * 2 - 34 * 2
        let itemWidth = (contentWidth / 7)
        self.itemSize = CGSize(width: itemWidth, height: 36)
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 重写滚动时停下的位置
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }
        if proposedContentOffset.x == 0 {
            return proposedContentOffset
        }
        // 获取这个范围的布局数组
        guard let attributes = self.layoutAttributesForElements(in: CGRect(origin: proposedContentOffset, size: collectionView.bounds.size))
        else { return .zero }
        
        // 中心点
        let centerX = proposedContentOffset.x + collectionView.bounds.width / 2 // - 20
        
        var targetPoint = proposedContentOffset
        //查找最近的中心点，计算偏移量
        let moveDistanse = attributes
            .map({ $0.center.x - centerX })
            .sorted(by: { abs($0) < abs($1) })
            .first ?? 0
        targetPoint.x += moveDistanse
        return targetPoint
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let count = CGFloat(collectionView.numberOfItems(inSection: 0))
        let contentWidth = (count * itemSize.width) + ((count - 1) * minimumLineSpacing)
        return CGSize(width:sectionInset.left + sectionInset.right + contentWidth,
                      height: super.collectionViewContentSize.height)
    }
}

private class SimpleLabelCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.font = UIFont(name: YHFontName.Helve_Bold, size: 30)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let label = UILabel()
}

private class IndicatorView: UIView {
    convenience init() {
        self.init(frame: .zero)
        self.isUserInteractionEnabled = false
        
        bgLayer.colors = [UIColor(red: 1, green: 0.74, blue: 0.91, alpha: 1).cgColor,
                          UIColor(red: 0.44, green: 0, blue: 1, alpha: 1).cgColor,
                          UIColor(red: 0.75, green: 0, blue: 1, alpha: 1).cgColor]
        bgLayer.locations = [0, 0, 1]
        bgLayer.startPoint = CGPoint(x: 0.5, y: 0)
        bgLayer.endPoint = CGPoint(x: 0.5, y: 1)
        bgLayer.cornerRadius = 5
        self.layer.addSublayer(bgLayer)
    }
    
    private let bgLayer = CAGradientLayer()
    override func layoutSubviews() {
        super.layoutSubviews()
        bgLayer.frame = self.bounds
    }
}
