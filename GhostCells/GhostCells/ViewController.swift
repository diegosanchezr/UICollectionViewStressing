//
//  ViewController.swift
//  GhostCells
//
//  Created by Diego Sanchez on 02/06/2016.
//  Copyright © 2016 Diego. All rights reserved.
//

// Dirty playground to show Ghost cells when doing reload data while performBatchUpdates animations are still running

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var items: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.collectionView?.registerClass(BlueCell.self, forCellWithReuseIdentifier: "blue")
        self.collectionView?.registerClass(GrayCell.self, forCellWithReuseIdentifier: "gray")
        self.collectionView?.registerClass(GreenCell.self, forCellWithReuseIdentifier: "green")
        self.collectionView?.registerClass(RedCell.self, forCellWithReuseIdentifier: "red")
        self.collectionView?.registerClass(PurpleCell.self, forCellWithReuseIdentifier: "purple")
        self.items = ["blue"]
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        withDelay(1) {
            self.collectionView?.performBatchUpdates({
                //Current: self.items = ["blue"]
                self.items = ["blue", "gray", "red"]
                self.collectionView?.insertItemsAtIndexPaths([
                    NSIndexPath(forItem: 1, inSection: 0),
                    NSIndexPath(forItem: 2, inSection: 0),
                ])
            }, completion: nil)

            withDelay(0.1, block: {
                self.collectionView?.layer.removeAllAnimations()
                self.collectionView?.subviews.forEach { $0.layer.removeAllAnimations() }
                self.items = ["gray", "purple", "green", "blue", "red", "red"]
                self.collectionView?.reloadData()
                self.collectionView?.dataSource = nil
                self.collectionView?.reloadData()
                self.collectionView?.dataSource = self
                self.collectionView?.reloadData()
                if let bounds = self.collectionView?.bounds {
                    let bounds2 = bounds.offsetBy(dx: 0, dy: 1)
                    self.collectionView?.bounds = bounds2
                    self.collectionView?.layoutIfNeeded()
                    self.collectionView?.bounds = bounds
                    self.collectionView?.layoutIfNeeded()

                }
                self.collectionView?.reloadData()

                // Bug:
                // AR: Color, height
                // blue, 300 - should be gray cell, height matches the one for gray
                // gray, 20 - should be purple, height matches the one for purple
                // red, 400 - should be green, height matches the one for green
                // ...
                // Scrolling down and up fixes the cells
                // Workaround:
//                UIView.performWithoutAnimation({ 
//                    self.collectionView?.reloadSections(NSIndexSet(index: 0))
//                })

            })
        }
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(items[indexPath.item], forIndexPath: indexPath)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height: CGFloat
        switch self.items[indexPath.item] {
        case "blue":
            height = 200
        case "gray":
            height = 300
        case "green":
            height = 400
        case "red":
            height = 500
        case "purple":
            height = 20
        default:
            height = 20
        }
        return CGSize(width: collectionView.bounds.width, height: height)
    }
}

class BlueCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blueColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GrayCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class GreenCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.greenColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RedCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PurpleCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.purpleColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func withDelay(delay: NSTimeInterval, block: () -> Void) {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue(), block)
}
