//
//  JZRefreshBaseView.swift
//  JZRefresh
//
//  Created by Jun Zhang on 16/8/26.
//  Copyright © 2016年 Jun Zhang. All rights reserved.
//

import UIKit

public class JZRefreshBaseView: UIView {

    public var scrollView: UIScrollView!
    public var action: Selector?
    public var performTarget: AnyObject?


    public func add(target: AnyObject, action: Selector?) {
        self.action = action
        self.performTarget = target
        
    }

    public func beginRefresh() {
        
    }
    
    public func endRefresh() {
        
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        guard let scrollView = newSuperview as? UIScrollView else {
            return
        }
        
        if self.scrollView != scrollView {
            removeobservers()
            self.scrollView = scrollView
            addObservers()
        }
    }
    public func addObservers() {
        scrollView?.addObserver(self, forKeyPath: KeyPath.contentOffset, options: .New, context: nil)
        scrollView?.addObserver(self, forKeyPath: KeyPath.PanGestureRecognizerState, options: .New, context: nil)
        
    }
    
    public func removeobservers() {
        scrollView?.removeObserver(self, forKeyPath: KeyPath.contentOffset)
        scrollView?.removeObserver(self, forKeyPath: KeyPath.PanGestureRecognizerState)
    }
    
}
