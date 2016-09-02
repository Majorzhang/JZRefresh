//
//  JZImageView.swift
//  JZImageView
//
//  Created by Jun Zhang on 16/8/11.
//  Copyright © 2016年 Jun Zhang. All rights reserved.
//

import UIKit

struct JZKeyPath {
    static let image = "image"
    static let frame = "frame"
    static let contentMode = "contentMode"
}

struct JZPointer {
    static var radius: UInt32 = 0
}

public class JZImageView: UIImageView {
    
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            if cornerRadius != oldValue {
                updateImage()
            }
        }
    }
    
     convenience init() {
        self.init(frame: CGRectMake(0, 0, 30, 30))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObservers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addObservers()
    }
    
    private func updateImage() {
        if self.image == nil {
            return
        }
        var image: UIImage? = nil
        if self.bounds.width > 0 && self.bounds.height > 0 {
            UIGraphicsBeginImageContext(bounds.size)
            let c = UIGraphicsGetCurrentContext()
            if (c != nil) {
                let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
                CGContextAddPath(c, path.CGPath)
                CGContextClip(c)
                layer.renderInContext(c!)
                 image = UIGraphicsGetImageFromCurrentImageContext()
                image?.renderRadius = true
                UIGraphicsEndImageContext()
                
                
                self.image = image
    
            }
        }
        
        
        
    }
    
    private func addObservers() {
        addObserver(self, forKeyPath: JZKeyPath.image, options: .New, context: nil)
        addObserver(self, forKeyPath: JZKeyPath.frame, options: .New, context: nil)

    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath != nil {
            switch keyPath! {
            case JZKeyPath.frame:
                updateImage()
            case JZKeyPath.image:
                let newImage = change?["new"] as? UIImage
//                print(newImage?.renderRadius)
                if newImage != nil && newImage?.renderRadius == false {
                    updateImage()
                }
            case JZKeyPath.contentMode:
                updateImage()
            default:
                break
            }
        }
    }
    
}

extension UIImage {
   dynamic var renderRadius: Bool {
        set {
            objc_setAssociatedObject(self, &JZPointer.radius, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
          return  objc_getAssociatedObject(self, &JZPointer.radius) as? Bool ?? false
        }
    }
}

