//
//  JZRefreshFooter.swift
//  JZRefresh
//
//  Created by Jun Zhang on 16/8/26.
//  Copyright © 2016年 Jun Zhang. All rights reserved.
//

import UIKit

public class JZRefreshFooter: JZRefreshBaseView {
    
    public var shapeLayer = CAShapeLayer()
    public var imageView = JZImageView()
    var InsetTop: CGFloat = 0.0
    public var loadingOffSet: CGFloat = 0.0
    public var state: JZRefreshState = .Stopped{
        didSet {
            switch state {
            case .Loading:
                if state != oldValue {
                    beginRefresh()
                }
                print(state)
            case .Stopped:
                print(state)
                
                UIView.animateWithDuration(0.4, animations: {
                    self.scrollView.contentInset.top = 0
                })
            case .AnimatingToStopped:
                print(state)
                scrollView.contentInset.top = 0
            default:
                print("default")
            }
            
        }
    }
    
    
    public func addRotateAnimation() {
        let ani = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        ani.values = [G_PI * 2, 0]
        ani.fillMode = kCAFillModeRemoved
        ani.duration = 0.5
        ani.repeatCount = Float.infinity
        ani.removedOnCompletion = true
        ani.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)]
        //        ani.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        imageView.layer.addAnimation(ani, forKey: "rotate")
        
        
        let shapeAni = CABasicAnimation(keyPath: "strokeColor")
        shapeAni.fromValue = UIColor.redColor().CGColor
        shapeAni.toValue = UIColor.yellowColor().CGColor
        shapeAni.duration = 2
        shapeAni.repeatCount = Float.infinity
        shapeAni.fillMode = kCAFillModeRemoved
        shapeAni.removedOnCompletion = false
        shapeAni.autoreverses = true
        shapeLayer.addAnimation(shapeAni, forKey: "strokeColor")
        
        let lineWidthAni = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAni.fromValue = 1
        lineWidthAni.toValue = 4
        lineWidthAni.duration = 1
        lineWidthAni.repeatCount = Float.infinity
        lineWidthAni.fillMode = kCAFillModeRemoved
        lineWidthAni.removedOnCompletion = false
        lineWidthAni.autoreverses = true
        shapeLayer.addAnimation(lineWidthAni, forKey: "lineWidth")
        
    }
    
    public override func endRefresh() {
        state = .Stopped
        imageView.layer.removeAnimationForKey("rotate")
        shapeLayer.removeAnimationForKey("lineWidth")
        shapeLayer.removeAnimationForKey("strokeColor")
    }
    
    public override func beginRefresh() {
        if self.scrollView.contentInset.top == 0 {
            UIView.animateWithDuration(0.2, animations: {
                self.scrollView.contentInset.top = 70
            })
        }
        addRotateAnimation()
        if let SEL = self.action {
            self.performTarget?.performSelector(SEL)
        }
    }
    
    
    private lazy var identityTransform: CATransform3D = {
        var transform = CATransform3DIdentity
        transform.m34 = CGFloat(1.0 / -500.0)
        return transform
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bounds.size.height = keyHeaderHeight
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        shapeLayer.lineWidth = 1
        layer.addSublayer(shapeLayer)
        imageView.center = currentCenter()
        imageView.image = UIImage(named: "Image")
        imageView.cornerRadius = 15
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(screenRotate), name: UIDeviceOrientationDidChangeNotification, object: nil)
        addSubview(imageView)
    }
    
    func screenRotate() {
        setNeedsDisplay()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func currentPath(progress: CGFloat) -> CGPath{
        let point = currentCenter()
        imageView.center = point
        let path = UIBezierPath(arcCenter: point, radius: 20, startAngle: G_PI * -0.5, endAngle: G_PI * -0.5 + G_PI * 2 * progress, clockwise: true)
        return path.CGPath
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.frame.size.width = scrollView.frame.size.width
        self.frame.origin.y = scrollView.frame.origin.y - keyHeaderHeight
        shapeLayer.path = currentPath(0)
        imageView.layer.transform = identityTransform
    }
    
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == KeyPath.contentOffset {
            if state == .AnimatingBounce {
                print(loadingOffSet)
                self.scrollView.contentInset.top = self.loadingOffSet
                state = .Loading
                UIView.animateWithDuration(0.418, delay: 0, usingSpringWithDamping: 1.8, initialSpringVelocity: 180, options: .CurveEaseInOut, animations: {
                    self.scrollView.contentInset.top = self.InsetTop
                    
                    }, completion: { (Bool) in
                        
                })
            } else if state != .Loading {
                InsetTop =  -scrollView.contentOffset.y
                if InsetTop > keyHeaderHeight {
                    InsetTop = keyHeaderHeight
                } else if InsetTop < 0 {
                    InsetTop = 0
                    state = .Stopped
                }
                scrollView.contentInset.top = InsetTop
                self.frame.origin.y = scrollView.frame.origin.y - keyHeaderHeight
                print(InsetTop)
                //            print(-scrollView.contentOffset.y)
                var value = -scrollView.contentOffset.y - keyHeaderHeight
                if value < 0 {
                    value = 0
                }
                var progress = value / keyHeaderHeight * 2
                if progress > 1.0 {
                    progress = 1.0
                }
                shapeLayer.path = currentPath(progress)
                var transform = CATransform3DIdentity
                transform.m34 = CGFloat(1.0 / -500.0)
                imageView.layer.transform = CATransform3DRotate(transform,  G_PI * 2 * progress, 0, 0, 1)
                
            }
        }
        if keyPath == KeyPath.PanGestureRecognizerState {
            if let gestureState = scrollView?.panGestureRecognizer.state where gestureState.isState([.Ended, .Cancelled, .Failed]) {
                if state == .Loading {
                    return
                }
                if -scrollView.contentOffset.y - InsetTop > keyHeaderHeight * 0.5 {
                    loadingOffSet = -scrollView.contentOffset.y - InsetTop
                    state = .AnimatingBounce
                } else {
                    state = .Stopped
                }
                print(scrollView.dragging)
                print(gestureState.rawValue)
            }
        }
        
        
    }
    
    private func currentCenter() -> CGPoint {
        var point = center
        if (self.layer.presentationLayer() != nil) {
            point = (layer.presentationLayer()?.position)!
        }
        point.y += InsetTop / 2 + bounds.height / 2
        return point
    }
    
}
