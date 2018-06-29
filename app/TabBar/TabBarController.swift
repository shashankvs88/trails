//

import UIKit
import FrostedSidebar
import RevealingSplashView


class TabBarController: UITabBarController, UITabBarControllerDelegate {
	
	var sidebar: FrostedSidebar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "youtube")!, iconInitialSize: CGSize(width: 70, height: 70),  backgroundColor: UIColor.black)
        
    
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.woobleAndZoomOut
        //Starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
        }
        
		delegate = self
		tabBar.isHidden = true
		
		moreNavigationController.navigationBar.isHidden = true
		
		sidebar = FrostedSidebar(itemImages: [
			UIImage(named: "youtube")!,
			UIImage(named: "photos")!],
			colors: [
				UIColor(red: 240/255, green: 159/255, blue: 254/255, alpha: 1),
				UIColor(red: 255/255, green: 137/255, blue: 167/255, alpha: 1)],
			selectionStyle: .single)
        sidebar.selectedIndices = NSMutableIndexSet(index: 0)
		sidebar.actionForIndex = [
			0: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 0}) },
			1: {self.sidebar.dismissAnimated(true, completion: { finished in self.selectedIndex = 1}) }]
	}
	
}
