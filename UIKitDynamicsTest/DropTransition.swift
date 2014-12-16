//
//  DropTransition.swift
//  UIKitDynamicsTest
//
//  Created by gentle on 2014/12/17.
//  Copyright (c) 2014年 gentlesoft. All rights reserved.
//

import UIKit

class DropTransition: NSObject, UIViewControllerAnimatedTransitioning, UIDynamicAnimatorDelegate {
    
    private var transitionContext : UIViewControllerContextTransitioning?
    private lazy var gravity : UIGravityBehavior = {
        let gravity = UIGravityBehavior()
        gravity.gravityDirection = CGVector(dx: 0.5, dy: 1)
        return gravity
    }()
    private let collision = UICollisionBehavior()
    private lazy var dynamicItem : UIDynamicItemBehavior = {
        let dynamicItem = UIDynamicItemBehavior()
        dynamicItem.elasticity = 0.5
        dynamicItem.resistance = 0.8
        return dynamicItem
    }()
    
    private var animator : UIDynamicAnimator?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
        let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view

        var canvas = UIView(frame: CGRect(x: -from.bounds.width * 0.5, y: -from.bounds.height, width: from.bounds.width * 1.5, height: from.bounds.height * 2))
        canvas.addSubview(to)

        self.dynamicItem.addItem(to)
        self.gravity.addItem(to)
        self.collision.addItem(to)
        self.collision.translatesReferenceBoundsIntoBoundary = true
        
        self.animator = UIDynamicAnimator(referenceView: canvas)
        self.animator?.addBehavior(self.gravity)
        self.animator?.addBehavior(self.collision)
        self.animator?.addBehavior(self.dynamicItem)
        self.animator?.delegate = self
  
        transitionContext.containerView().addSubview(canvas)
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        self.animator = nil
    }
    
    // MARK: - UIDynamicAnimatorDelegate
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        self.transitionContext?.completeTransition(true)
    }
}
