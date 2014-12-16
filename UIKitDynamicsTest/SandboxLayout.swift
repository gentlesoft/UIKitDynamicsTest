//
//  SandboxLayout.swift
//  UIKitDynamicsTest
//
//  Created by gentle on 2014/12/06.
//  Copyright (c) 2014年 gentlesoft. All rights reserved.
//

import UIKit
import CoreMotion

@objc protocol SandboxDelegate {
    
    func initSand(indexPath: NSIndexPath) -> CGRect
    
}

class SandboxLayout: UICollectionViewLayout, UIDynamicAnimatorDelegate {

    @IBOutlet var controller: SandboxCollectionViewController!
    @IBOutlet var sandBoxDelegate: SandboxDelegate!
    
    private let motion = CMMotionManager()
    private let collision = UICollisionBehavior()
    private let dynamicItem = UIDynamicItemBehavior()
    private let gravity = UIGravityBehavior()
    
    lazy var animator : UIDynamicAnimator = {
        self.dynamicItem.elasticity = 1.0
        self.dynamicItem.resistance = 1.0
        
        let animator : UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        animator.delegate = self
        animator.addBehavior(self.gravity)
        animator.addBehavior(self.collision)
        animator.addBehavior(self.dynamicItem)

        return animator
    }()
        /*
        self.collectionView
                for (int i = 0; i < [self.collectionView numberOfItemsInSection:SECTION_MAPS]; ++i) {
                    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:SECTION_MAPS];
                    UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:indexPath];
                    [self.collision addItem:attr];
                    [self.dynamicItem addItem:attr];
                }
                UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:SECTION_ROOT]];
                self.attachment = [[UIAttachmentBehavior alloc] initWithItem:attr attachedToAnchor:self.screenCenter];
                [self.collision addItem:attr];
                [self.dynamicItem addItem:attr];
                //    }
                
                UIDynamicAnimator* animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
                animator.delegate = self;
                [animator addBehavior:self.attachment];
                [animator addBehavior:self.collision];
                [animator addBehavior:self.dynamicItem];
                
                return animator;
        }
        */

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sandBoxDelegate = self.controller

        self.motion.startDeviceMotionUpdatesToQueue(NSOperationQueue(), withHandler: { (motion: CMDeviceMotion!, error: NSError!) -> Void in
            self.gravity.angle = CGFloat(motion.attitude.yaw)D
        })
    }
    
    func setCollision() {
        let f = self.collectionView!.bounds
        self.collision.addBoundaryWithIdentifier("bottom", fromPoint: CGPoint(x: 0, y: f.height), toPoint: CGPoint(x: f.width, y: f.height))
        self.collision.addBoundaryWithIdentifier("left", fromPoint: CGPoint(x: 0, y: 0), toPoint: CGPoint(x: 0, y: f.height))
        self.collision.addBoundaryWithIdentifier("right", fromPoint: CGPoint(x: f.width, y: 0), toPoint: CGPoint(x: f.width, y: f.height))
        self.collision.addBoundaryWithIdentifier("top", fromPoint: CGPoint(x: 0, y: 0), toPoint: CGPoint(x: f.width, y: 0))        
    }

    override func collectionViewContentSize() -> CGSize {
        if let view = self.collectionView {
            return view.bounds.size
        }
        else {
            return CGSizeZero
        }
    }

    override func prepareLayout() {
        super.prepareLayout()
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attr = self.animator.layoutAttributesForCellAtIndexPath(indexPath)
        if attr == nil {
            attr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attr.frame = self.sandBoxDelegate.initSand(indexPath)
        }
        return attr
    }

    /*
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        <#code#>
    }
    - (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
    {
    if (![kind isEqualToString:@"node"])
    return nil;
    
    NSIndexPath* parentIndexPath = [self.mapLayoutDelegate collectionView:self.collectionView layout:self indexPathForParentAtIndexPath:indexPath];
    if (parentIndexPath == nil)
    return nil;
    
    NodeViewAttributes* attr = [NodeViewAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    attr.indexPath = indexPath;
    attr.nodeAttr = [self layoutAttributesForItemAtIndexPath:indexPath];
    attr.parentAttr = [self layoutAttributesForItemAtIndexPath:parentIndexPath];
    [attr setAttrFrame];
    attr.zIndex = indexPath.item;
    
    return attr;
    }
*/
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return self.animator.itemsInRect(rect)
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        super.prepareForCollectionViewUpdates(updateItems)

        for updateItem in updateItems {
            switch updateItem.updateAction! {
            case UICollectionUpdateAction.Insert:
                let attr = self.layoutAttributesForItemAtIndexPath(updateItem.indexPathAfterUpdate)
                self.collision.addItem(attr)
                self.dynamicItem.addItem(attr)
                self.gravity.addItem(attr)
            default:
                break;
            }
        }
    }
    
    // MARK: - UIDynamicAnimatorDelegate

}
