//
//  JZScrollViewExtension.swift
//  JZRefresh
//
//  Created by Jun Zhang on 16/8/26.
//  Copyright © 2016年 Jun Zhang. All rights reserved.
//

import UIKit

extension UIScrollView {
    var header: JZRefreshHeader {
        set {
            objc_setAssociatedObject(self, &UnsafePointer.refreshHeader, newValue, .OBJC_ASSOCIATION_RETAIN)
            
            //            if header != newValue {
            header.removeFromSuperview()
            bounces = true
            self.addSubview(newValue)
            //            }
        }
        get {
            return objc_getAssociatedObject(self,  &UnsafePointer.refreshHeader) as? JZRefreshHeader ?? JZRefreshHeader()
        }
    }
    
    var footer: JZRefreshFooter {
        set {
            objc_setAssociatedObject(self, &UnsafePointer.refreshFooter, newValue, .OBJC_ASSOCIATION_RETAIN)
            
            //            if header != newValue {
            footer.removeFromSuperview()
            bounces = true
            self.addSubview(newValue)
            //            }
        }
        get {
            return objc_getAssociatedObject(self,  &UnsafePointer.refreshFooter) as? JZRefreshFooter ?? JZRefreshFooter()
        }

    }
    
}
