//
//  CustomTabBar.swift
//  Budget
//
//  Created by Yuri Pereira on 3/19/16.
//  Copyright © 2016 Budget. All rights reserved.
//


import UIKit

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class CustomTabBar: UIViewController {
//    var tabBar: UITabBar?
    static func custom(inout tabBar: UITabBar) {
//        tabBar = self.tabBarController!.tabBar
//        tabBar.selectionIndicatorImage = UIImage().makeImageWithColorAndSize(UIColor.blueColor(), size: CGSizeMake(tabBar.frame.width/CGFloat(tabBar.items!.count), tabBar.frame.height))
        
        // To change tintColor for unselect tabs
        for item in tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(Color.uicolorFromHex(0x9ee9e1)).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }
}