//
//  AppTheme.swift
//  AppStructure
//
//  Created by Muhammad Azher on 10/25/17.
//  Copyright © 2017 FahidAttique. All rights reserved.
//

import Foundation
import UIKit

class AppTheme {
    
    // MARK:- Functions
    
    
    class func vendColor(_ r: Float, g: Float, b: Float) -> UIColor {
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: 1.0)
    }
    
    class func themeColor() -> UIColor {
        return UIColor.darkGray
    }
    
    class func themeRedColor() -> UIColor {
        return UIColor(red:0.88, green:0.32, blue:0, alpha:1)
    }
    
    class func themeYellowColor() -> UIColor {
        return UIColor(red:255/255, green:158/255, blue:15/255, alpha:1)
    }
    
    class func navBarthemeColor() -> UIColor {
        return UIColor.darkGray
    }
    
    class func barItemsTint() -> UIColor {
        return .white
    }
    
    class func lightBlue() -> UIColor {
        return UIColor(red: 57/255, green: 161/255, blue: 248/255, alpha: 1.0)
    }
    
    class func lightYellow() -> UIColor {
        return UIColor(red: 255/255, green: 249/255, blue: 210/255, alpha: 1.0)
    }
    
    class func lightgreen() -> UIColor {
        return UIColor(red: 169/255, green: 219/255, blue: 134/255, alpha: 1.0)
    }
    
    class func lightBG() -> UIColor {
        return UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1.0)
    }
    
    class func lightGrayBG() -> UIColor {
        return UIColor(red: 243/255, green: 243/255, blue: 242/255, alpha: 1.0)
    }

}


