import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupColors()
    }
    
    fileprivate func setupViewControllers() {
        let motorcycleVC = MotorcycleViewController()
        motorcycleVC.tabBarItem.image = def_tabBarMotorcycleIcon
        motorcycleVC.tabBarItem.title = NSLocalizedString("tabBarItem1", comment: "")
        
        let detectVC = DetectViewController()
        detectVC.tabBarItem.image = def_tabBarDetectIcon
        detectVC.tabBarItem.title = NSLocalizedString("tabBarItem2", comment: "")
        
        let detailsVC = DetailsViewController()
        detailsVC.tabBarItem.image = def_tabBarDetailsIcon
        detailsVC.tabBarItem.title = NSLocalizedString("tabBarItem3", comment: "")
        
        viewControllers = [motorcycleVC, detectVC, detailsVC]
    }
    
    fileprivate func setupColors() {
        tabBar.tintColor = def_tabBarSelectedColor
        tabBar.unselectedItemTintColor = def_tabBarUnselectedColor
        tabBar.backgroundColor = def_tabBarBackgroundColor
    }
}

