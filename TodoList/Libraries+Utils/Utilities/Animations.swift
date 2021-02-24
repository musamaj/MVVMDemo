//
//  Animations.swift
//  TodoList
//
//  Created by Usama Jamil on 18/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import UIKit


class Animations: NSObject {

    class func toggleMenu(menuView: UIView, controller: UIViewController, tabBarHeight: CGFloat, toggle: Bool) {
        
        if toggle {
            self.showMenu(menuView: menuView, controller: controller, tabBarHeight: tabBarHeight)
        } else {
            self.hideMenu(menuView: menuView, controller: controller, tabBarHeight: tabBarHeight)
        }
    }
    
    class func showMenu(menuView: UIView, controller: UIViewController, tabBarHeight: CGFloat)
    {
        
        let height = menuView.frame.height
        menuView.frame.size.width = controller.view.frame.size.width
        menuView.frame.origin.y = controller.view.frame.height
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            if !menuView.isDescendant(of: controller.view) {
                controller.view.addSubview(menuView)
            }
            menuView.frame.origin.y -= height+tabBarHeight
            //controller.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    class func hideMenu(menuView: UIView, controller: UIViewController, tabBarHeight: CGFloat) {
        if controller.view.subviews.contains(menuView) {
            let height = menuView.frame.height
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                menuView.frame.origin.y += height + tabBarHeight
                //controller.view.layoutIfNeeded()
                menuView.removeFromSuperview()
            }, completion: nil)
        }
    }

}
