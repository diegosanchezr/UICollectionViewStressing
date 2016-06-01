//
//  Layout.swift
//  CollectionViewStress
//
//  Created by Diego Sanchez on 29/05/2016.
//  Copyright © 2016 Diego. All rights reserved.
//

import Foundation
import UIKit

public protocol ChatCollectionViewLayoutDelegate: class {
    func chatCollectionViewLayoutModel() -> ChatCollectionViewLayoutModel
}

public struct ChatCollectionViewLayoutModel {
    let contentSize: CGSize
    let layoutAttributes: [UICollectionViewLayoutAttributes]
    let layoutAttributesBySectionAndItem: [[UICollectionViewLayoutAttributes]]
    let calculatedForWidth: CGFloat

    public static func createModel(collectionViewWidth: CGFloat, itemsLayoutData: [(height: CGFloat, bottomMargin: CGFloat)]) -> ChatCollectionViewLayoutModel {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        var layoutAttributesBySectionAndItem = [[UICollectionViewLayoutAttributes]]()
        layoutAttributesBySectionAndItem.append([UICollectionViewLayoutAttributes]())

        var verticalOffset: CGFloat = 0
        for (index, layoutData) in itemsLayoutData.enumerate() {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let (height, bottomMargin) = layoutData
            let itemSize = CGSize(width: collectionViewWidth, height: height)
            let frame = CGRect(origin: CGPoint(x: 0, y: verticalOffset), size: itemSize)
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = frame
            layoutAttributes.append(attributes)
            layoutAttributesBySectionAndItem[0].append(attributes)
            verticalOffset += itemSize.height
            verticalOffset += bottomMargin
        }

        return ChatCollectionViewLayoutModel(
            contentSize: CGSize(width: collectionViewWidth, height: verticalOffset),
            layoutAttributes: layoutAttributes,
            layoutAttributesBySectionAndItem: layoutAttributesBySectionAndItem,
            calculatedForWidth: collectionViewWidth
        )
    }
}


public class ChatCollectionViewLayout: UICollectionViewLayout {
    var layoutModel: ChatCollectionViewLayoutModel!
    public weak var delegate: ChatCollectionViewLayoutDelegate?

    // Optimization: after reloadData we'll get invalidateLayout, but prepareLayout will be delayed until next run loop.
    // Client may need to force prepareLayout after reloadData, but we don't want to compute layout again in the next run loop.
    private var layoutNeedsUpdate = true
    public override func invalidateLayout() {
        super.invalidateLayout()
        self.layoutNeedsUpdate = true
    }

    public override func prepareLayout() {
        super.prepareLayout()
        guard self.layoutNeedsUpdate else { return }
        guard let delegate = self.delegate else { return }
        var oldLayoutModel = self.layoutModel
        self.layoutModel = delegate.chatCollectionViewLayoutModel()
        self.layoutNeedsUpdate = false
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            // Dealloc of layout with 5000 items take 25 ms on tests on iPhone 4s
            // This moves dealloc out of main thread
            if oldLayoutModel != nil {
                // Use nil check above to remove compiler warning: Variable 'oldLayoutModel' was written to, but never read
                oldLayoutModel = nil
            }
        }
    }

    public override func collectionViewContentSize() -> CGSize {
        if self.layoutNeedsUpdate {
            self.prepareLayout()
        }
        return self.layoutModel?.contentSize ?? .zero
    }

    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.layoutModel.layoutAttributes.filter { $0.frame.intersects(rect) }
    }

    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section < self.layoutModel.layoutAttributesBySectionAndItem.count && indexPath.item < self.layoutModel.layoutAttributesBySectionAndItem[indexPath.section].count {
            return self.layoutModel.layoutAttributesBySectionAndItem[indexPath.section][indexPath.item]
        }
        assert(false, "Unexpected indexPath requested:\(indexPath)")
        return nil
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return self.layoutModel.calculatedForWidth != newBounds.width
    }
}
