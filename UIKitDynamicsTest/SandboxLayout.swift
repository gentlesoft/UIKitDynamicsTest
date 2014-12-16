//
//  SandboxLayout.swift
//  UIKitDynamicsTest
//
//  Created by gentle on 2014/12/06.
//  Copyright (c) 2014年 gentlesoft. All rights reserved.
//

import UIKit

@objc protocol SandboxDelegate {
    
    func initSand(indexPath: NSIndexPath) -> CGRect
    
}

class SandboxLayout: UICollectionViewLayout, UIDynamicAnimatorDelegate {

    @IBOutlet var controller: SandboxCollectionViewController!
    @IBOutlet var sandBoxDelegate: SandboxDelegate!
    
    let gravity = UIGravityBehavior()
    private let collision = UICollisionBehavior()
    private let dynamicItem = UIDynamicItemBehavior()
    
    lazy var animator : UIDynamicAnimator = {
        self.collision.translatesReferenceBoundsIntoBoundary = true
        self.dynamicItem.elasticity = 1.0
        self.dynamicItem.resistance = 1.0
        
        let animator : UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        animator.delegate = self
        animator.addBehavior(self.gravity)
        animator.addBehavior(self.collision)
        animator.addBehavior(self.dynamicItem)

        return animator
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sandBoxDelegate = self.controller
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
}
