//
//  HockeyViewController.swift
//  UIKitDynamicsTest
//
//  Created by gentle on 2014/12/17.
//  Copyright (c) 2014年 gentlesoft. All rights reserved.
//

import UIKit

class HockeyViewController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet private var tableView: UIView!
    @IBOutlet private var packView: UIView!
    @IBOutlet private var malletView: UIView!
    @IBOutlet private var gestureRecognizer: UIPanGestureRecognizer!
    
    private let collision = UICollisionBehavior()
    private let dynamicItem = UIDynamicItemBehavior()
    private var attachment : UIAttachmentBehavior!
    
    private var tapPos = CGPoint()
    
    lazy var animator : UIDynamicAnimator = {
        let animator : UIDynamicAnimator = UIDynamicAnimator(referenceView: self.tableView)
        
        self.collision.translatesReferenceBoundsIntoBoundary = true
        self.dynamicItem.allowsRotation = false
        self.dynamicItem.elasticity = 1
        self.dynamicItem.resistance = 0.01
        self.dynamicItem.friction = 0.01
        
        self.dynamicItem.addItem(self.packView)
        self.dynamicItem.addItem(self.malletView)
        self.collision.addItem(self.packView)
        self.collision.addItem(self.malletView)
        self.attachment = UIAttachmentBehavior(item: self.malletView, attachedToAnchor: self.malletView.center)
        
        animator.addBehavior(self.collision)
        animator.addBehavior(self.dynamicItem)
        animator.addBehavior(self.attachment)
        
        return animator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.packView.layer.cornerRadius = 30
        self.gestureRecognizer.addTarget(self, action: "handleGesture:")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let push = UIPushBehavior(items: [self.packView], mode: UIPushBehaviorMode.Instantaneous)
        push.pushDirection = CGVector(dx: 10, dy: 10)
        push.magnitude = 3
        self.animator.addBehavior(push)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Gesture
    
    func handleGesture(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case UIGestureRecognizerState.Began:
            self.tapPos = self.attachment.anchorPoint
        case UIGestureRecognizerState.Changed:
            let pos = recognizer.translationInView(self.malletView)
            self.attachment.anchorPoint = CGPoint(x: self.tapPos.x + pos.x, y: self.tapPos.y + pos.y)
        default:
            break
        }
    }
    
    // MARK: - UIDynamicAnimatorDelegate
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
    }
}
