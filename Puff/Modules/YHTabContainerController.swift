import UIKit
import Pageboy
import SnapKit
import Toast_Swift

class YHTabContainerController: PageboyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        self.isScrollEnabled = false
        
        view.addSubview(tabbarView)
        tabbarView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        loadLocalData()
    }

    private lazy var viewControllers: [UIViewController] = {
        let breathPage = YHBreathBuildViewController()
        let bookPage = YHAstrologyMainViewController()
        let personal = YHCurrentUserInfoCollectionPage()
        return [breathPage, bookPage, personal]
    }()
    
    private lazy var tabbarView: TabbarView = {
        let contentView = TabbarView()
        contentView.delegate = self
        return contentView
    }()
    
    private func loadLocalData() {
        Task {
            do {
                self.view.makeToastActivity(.center)
                try await AcountLaunchRunner.getData()
                self.view.hideToastActivity()
            } catch let error {
                print(#function, error)
                self.view.hideToastActivity()
                let err_msg = "No network, please try again later."
                self.view.makeToast(err_msg)
            }
        }
    }
}

extension YHTabContainerController: TabbarViewDelegate, PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    fileprivate func tabbarView(_ tabbarView: TabbarView, shouldSelectedItemAt index: Int) -> Bool {
        return true
    }
    fileprivate func tabbarView(_ tabbarView: TabbarView, didSelectedItemAt index: Int) {
        self.scrollToPage(.at(index: index), animated: true)
    }
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAt index: PageboyViewController.PageIndex,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAt index: PageboyViewController.PageIndex,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        tabbarView.setSelectTab(on: index)
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didReloadWith currentViewController: UIViewController,
                               currentPageIndex: PageboyViewController.PageIndex) {
        
    }
}

private class TabbarView: UIView {
    convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(red: 0, green: 0.15, blue: 0.31, alpha: 0.11).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -4)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 25
        
        
        let stack = UIStackView()
        stack.distribution = .fillEqually
        self.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(WindowLetValue.tabbarHeight)
            make.bottom.equalToSuperview().inset(WindowLetValue.safeAreaInsets.bottom)
        }
        
        let iconUnselectNameList = [
            "tabbarPage_breath_unselect",
            "tabbarPage_book_unselect",
            "tabbarPage_personal_unselect",
        ]
        
        let iconSelectedNameList = [
            "tabbarPage_breath_selected",
            "tabbarPage_book_selected",
            "tabbarPage_personal_selected",
        ]
        
        for idx in 0 ..< iconUnselectNameList.count {
            let btn = UIButton()
            btn.setImage(UIImage(named: iconUnselectNameList[idx]), for: .normal)
            btn.setImage(UIImage(named: iconSelectedNameList[idx]), for: .selected)
            btn.isSelected = (idx == 0)
            
            btn.tag = idx
            btn.addTarget(self, action: #selector(didTouchTabbar(btn:)), for: .touchUpInside)
            stack.addArrangedSubview(btn)
            tabbarBtnList.append(btn)
        }
    }
    
    private var tabbarBtnList: [UIButton] = []
    weak var delegate: TabbarViewDelegate? = nil
    @objc private func didTouchTabbar(btn: UIButton) {
        let index = btn.tag
        guard (delegate?.tabbarView(self, shouldSelectedItemAt: index) ?? false) else {
            return
        }
        setSelectTab(on: index)
        delegate?.tabbarView(self, didSelectedItemAt: index)
    }
    
    func setSelectTab(on index: Int) {
        tabbarBtnList.forEach({ $0.isSelected = ($0.tag == index) })
    }
}

private protocol TabbarViewDelegate: AnyObject {
    func tabbarView(_ tabbarView: TabbarView, didSelectedItemAt index: Int)
    func tabbarView(_ tabbarView: TabbarView, shouldSelectedItemAt index: Int) -> Bool
}
