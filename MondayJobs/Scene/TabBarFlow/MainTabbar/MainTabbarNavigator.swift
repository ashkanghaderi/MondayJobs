
import Foundation
import Domain
import NetworkPlatform
import UIKit

class MainTabbarNavigator {
  
  private let navigationController: UINavigationController
  private let tabbarVC: UITabBarController
  private let services: Domain.UseCaseProvider
  
  init(services: Domain.UseCaseProvider, navigationController: UINavigationController, tabbar: UITabBarController) {
    self.navigationController = navigationController
    self.tabbarVC = tabbar
    self.services = services
  }
  
  func setup(withIndex index: Int = 0) {
    
    
    let tabbar = tabbarVC.tabBar
    tabbar.tintColor = AppColor.color2B7BBE
    
    //UITabBar.appearance().tintColor = UIColor.white
    let attributes = [NSAttributedString.Key.font: AppFont.labels.tabbar(), NSAttributedString.Key.foregroundColor: UIColor.clear]
    let attributes1 = [NSAttributedString.Key.font: AppFont.labels.tabbar(), NSAttributedString.Key.foregroundColor: AppColor.color2B7BBE]
    
    UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
    UITabBarItem.appearance().setTitleTextAttributes(attributes1, for: .selected)
    
    
    let tabHome = tabbar.items![0]
    tabHome.title = NSLocalizedString("title-home", comment: "") // tabbar titlee
    tabHome.image = UIImage(named: "TabIcon-Home") // deselect image
    tabHome.selectedImage = UIImage(named: "icon_home.png") // select image
    tabHome.imageInsets = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
   // tabHome.titlePositionAdjustment.vertical = tabHome.titlePositionAdjustment.vertical //+ 8// title position change
    
    let tabScore = tabbar.items![1]
    tabScore.title = NSLocalizedString("title-chat", comment: "")
    tabScore.image = UIImage(named: "TabIcon-Transaction")
    tabScore.selectedImage = UIImage(named: "TabIcon-Transaction")
    tabScore.imageInsets = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    //tabScore.titlePositionAdjustment.vertical = tabScore.titlePositionAdjustment.vertical
    
    let tabExtra = tabbar.items![2]
    tabExtra.title = NSLocalizedString("title_notifications", comment: "")
    tabExtra.image = UIImage(named: "TabIcon-Barcode")
    tabExtra.selectedImage = UIImage(named: "TabIcon-Barcode")
    tabExtra.imageInsets = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
   // tabExtra.titlePositionAdjustment.vertical = tabExtra.titlePositionAdjustment.vertical + 8

    let tabPro = tabbar.items![3]
    tabPro.title = NSLocalizedString("title_profile", comment: "")
    tabPro.image = UIImage(named: "TabIcon-Festival")
    tabPro.imageInsets = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    tabPro.selectedImage = UIImage(named: "TabIcon-Festival")
    //tabPro.titlePositionAdjustment.vertical = tabPro.titlePositionAdjustment.vertical //+ 8
    
    
    navigationController.modalTransitionStyle = .crossDissolve
    navigationController.pushViewController(tabbarVC, animated: true)
    
  }
  
  func toIndex(index: Int){
    tabbarVC.selectedIndex = index
  }
}
