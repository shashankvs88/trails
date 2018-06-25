//

import UIKit
import FrostedSidebar

class TabBarController: UITabBarController, UITabBarControllerDelegate {
	
	var sidebar: FrostedSidebar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
		tabBar.isHidden = true
		
		moreNavigationController.navigationBar.isHidden = true
		
		sidebar = FrostedSidebar(itemImages: [
			UIImage(named: "profile")!,
			UIImage(named: "star")!],
			colors: [
				UIColor(red: 240/255, green: 159/255, blue: 254/255, alpha: 1),
				UIColor(red: 255/255, green: 137/255, blue: 167/255, alpha: 1)],
			selectionStyle: .single)
		sidebar.actionForIndex = [
			0: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 0}) },
			1: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 1}) }]
	}
	
}
