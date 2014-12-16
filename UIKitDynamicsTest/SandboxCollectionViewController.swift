//
//  SandboxCollectionViewController.swift
//  UIKitDynamicsTest
//
//  Created by gentle on 2014/12/06.
//  Copyright (c) 2014年 gentlesoft. All rights reserved.
//

import UIKit
import CoreMotion

let reuseIdentifier = "SandCell"

class SandboxCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SandboxDelegate, UIGestureRecognizerDelegate {

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var tagGesture : UIGestureRecognizer!
    private let motion = CMMotionManager()
    private var sands: [CGPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.registerClass(SandCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        tagGesture?.addTarget(self, action: "handleTapGesture:")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        (self.collectionView.collectionViewLayout as? SandboxLayout)?.setCollision()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.motion.startDeviceMotionUpdatesToQueue(NSOperationQueue(), withHandler: { (motion: CMDeviceMotion!, error: NSError!) in
            if motion != nil {
                (self.collectionView.collectionViewLayout as? SandboxLayout)?.gravity.angle = CGFloat(motion.attitude.yaw + M_PI_2)
            }
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.motion.stopDeviceMotionUpdates()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    // MARK: Gesture
    
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case UIGestureRecognizerState.Ended:
            var pos = recognizer.locationInView(self.collectionView)
            sands.append(pos)
            self.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: sands.count - 1, inSection: 0)])
        default:
            break
        }
    }
    
    // MARK: SandboxDelefate

    func initSand(indexPath: NSIndexPath) -> CGRect {
        let size = CGSize(width: 10, height: 10)
        return CGRect(origin: self.sands[indexPath.item], size: size)
    }

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sands.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as SandCollectionViewCell
        cell.setAttr()
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
