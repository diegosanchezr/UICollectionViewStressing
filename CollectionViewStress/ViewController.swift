//
//  ViewController.swift
//  CollectionViewStress
//
//  Created by Diego Sanchez on 28/05/2016.
//  Copyright © 2016 Diego. All rights reserved.
//

import UIKit

// Dirty 'playground' to stress UICollectionView

let demoTexts = [
    "Lorem ipsum dolor sit amet 😇, https://github.com/badoo/Chatto consectetur adipiscing elit , sed do eiusmod tempor incididunt 07400000000 📞 ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore https://github.com/badoo/Chatto eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 07400000000 non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
]

func createRandomText(uid: Int) -> String {
    let maxText = demoTexts.first!
    let length: Int = 10 + Int(arc4random_uniform(150))
    let text = "\(maxText.substringToIndex(maxText.startIndex.advancedBy(length))) #:\(uid)"
    return text
}

struct TextItem: UniqueIdentificable {
    let uid: String
    let text: String
}

struct DataItem: UniqueIdentificable {
    let uid: String
    let type: Int
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }

        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

let layoutCache = NSCache()


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!

    let textSizingCell: TextMessageCollectionViewCell = {
        let cell = TextMessageCollectionViewCell.sizingCell()
        cell.baseStyle = BaseMessageCollectionViewCellDefaultStyle()
        cell.textMessageStyle = TextMessageCollectionViewCellDefaultStyle()
        return cell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.generateColors()

        let button = UIBarButtonItem(title: "Go!", style: .Plain, target: self, action: #selector(ViewController.toggleUpdates))
        self.navigationItem.rightBarButtonItem = button;
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.whiteColor()
    }

    var timer: NSTimer?
    @objc
    private func toggleUpdates() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.modifyDataSourceAndCollectionView), userInfo: nil, repeats: true)
        }
    }

    var palete: [String: UIColor] = [:]
    private func generateColors() {
        for i in 0...maxType {
            palete["\(i)"] = self.generateRandomColor()
        }
    }

    private func generateRandomColor() -> UIColor {
        let hue: CGFloat = (CGFloat(arc4random()) % 256) / 256
        let saturation: CGFloat = (CGFloat(arc4random()) % 128) / 256 + 0.5
        let brightness: CGFloat = (CGFloat(arc4random()) % 128) / 256 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 0.5)
    }

    var updateNumber: Int = 0
    @objc
    private func modifyDataSourceAndCollectionView() {
        var newDataStore = dataStore

        newDataStore += [self.createDataItem() as UniqueIdentificable]
        newDataStore += [self.createTextItem() as UniqueIdentificable]
        newDataStore += [self.createTextItem() as UniqueIdentificable]
        newDataStore = newDataStore.shuffle()
        newDataStore.removeLast()

        let changes = generateChanges(oldCollection: dataStore.map {$0}, newCollection: newDataStore.map { $0 })


        UIView.animateWithDuration(0.25, delay: 0, options: [.BeginFromCurrentState], animations: {
            print("BEFORE PERFORM BATCH UPDATES")
            self.printVisibleCells(context: "BEFORE PERFORM BATCH UPDATES")

            let current = self.updateNumber
            self.updateNumber += 1
            self.collectionView.performBatchUpdates({
                self.dataStore = newDataStore

                self.printVisibleCells(context: "INSIDE PERFORM BATCH UPDATES")
                print("DELETIONS:", changes.deletedIndexPaths)
                print("INSERTIONS:", changes.insertedIndexPaths)
                self.collectionView.deleteItemsAtIndexPaths(Array(changes.deletedIndexPaths))
                self.collectionView.insertItemsAtIndexPaths(Array(changes.insertedIndexPaths))
                for move in changes.movedIndexPaths {
                    print("MOVE", move.indexPathOld, "->", move.indexPathNew)
                    self.collectionView.moveItemAtIndexPath(move.indexPathOld, toIndexPath: move.indexPathNew)
                }

            }) { (finished) in
                print("COMPLETION", current, finished)
            }
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            self.printVisibleCells(context: "AFTER PERFORM BATCH UPDATES")

            print("AFTER PERFORM BATCH UPDATES")
        }, completion:nil)
    }

    private func printVisibleCells(context context: String) {
        var aux: [(indexPath: NSIndexPath, UnsafePointer<Void>)] = []
        self.collectionView.indexPathsForVisibleItems().forEach { (indexPath) in
            let cell = self.collectionView.cellForItemAtIndexPath(indexPath)!
            aux += [(indexPath: indexPath, cell: unsafeAddressOf(cell))]
        }
        print("VISIBLE CELLS '\(context)", aux)
    }

    private func createTextItem() -> TextItem {
        defer { lastId += 1 }
        return TextItem(uid: "\(lastId)", text: createRandomText(lastId))
    }

    let maxType: Int = 100

    var lastId: Int = 0
    private func createDataItem() -> DataItem {
        defer { lastId += 1 }
        return DataItem(uid: "\(lastId)", type: Int(arc4random_uniform(UInt32(maxType))))
    }

    var dataStore: [UniqueIdentificable] = []

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataStore.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if let _ = self.dataStore[indexPath.item] as? DataItem {
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("reuseId", forIndexPath: indexPath)
            print("cellForItemAtIndexPath:", indexPath, unsafeAddressOf(cell))
            configureCell(cell, atIndexPath: indexPath)
            return cell
        } else {
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("text", forIndexPath: indexPath) as! TextMessageCollectionViewCell
            print("cellForItemAtIndexPath:", indexPath, unsafeAddressOf(cell))
            configureCell(cell, atIndexPath: indexPath)
            return cell
        }
    }

    private func configureCell(cell: UICollectionViewCell, atIndexPath indexPath: NSIndexPath) {
        if let data = self.dataStore[indexPath.item] as? DataItem {
            let reuse = "\(data.type)"
            cell.backgroundColor = palete[reuse]
            print("configureCell:", indexPath, unsafeAddressOf(cell))
        } else {
            let cell = cell as! TextMessageCollectionViewCell
            let textItem = dataStore[indexPath.item] as! TextItem
            let viewModel = createTextViewModel(textItem.text)
            cell.performBatchUpdates({
                cell.textMessageViewModel = viewModel
                cell.textMessageStyle = TextMessageCollectionViewCellDefaultStyle()
                cell.baseStyle = BaseMessageCollectionViewCellDefaultStyle()
            }, animated: false, completion: nil)
        }
    }

    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        print("willDisplayCell:", indexPath, unsafeAddressOf(cell))

    }

    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        print("didEndDisplayingCell:", indexPath, unsafeAddressOf(cell))
    }

    func registerCells() {
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseId")
        self.collectionView.registerClass(TextMessageCollectionViewCell.self, forCellWithReuseIdentifier: "text")
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.collectionView.bounds.width
        let height: CGFloat
        if let data = self.dataStore[indexPath.item] as? DataItem {
            height = 10.0 + CGFloat(data.type)
            return CGSize(width: width, height: height)
        } else {
            let textItem = dataStore[indexPath.item] as! TextItem
            let viewModel = createTextViewModel(textItem.text)
            textSizingCell.textMessageViewModel = viewModel
            height = textSizingCell.sizeThatFits(CGSize(width: collectionView.bounds.width, height: .max)).height
            return CGSize(width: width, height: height)
        }
    }

}

extension ViewController: ChatCollectionViewLayoutDelegate {
    func chatCollectionViewLayoutModel() -> ChatCollectionViewLayoutModel {
        var layoutData: [(height: CGFloat, bottomMargin: CGFloat)] = []
        for i in 0..<self.dataStore.count {
            let height: CGFloat
            if let data = self.dataStore[i] as? DataItem {
                height = 10.0 + CGFloat(data.type)
            } else {
                let textItem = dataStore[i] as! TextItem
                let viewModel = createTextViewModel(textItem.text)
                textSizingCell.textMessageViewModel = viewModel
                height = textSizingCell.sizeThatFits(CGSize(width: collectionView.bounds.width, height: .max)).height
            }
            layoutData.append((height: height, bottomMargin: 10))
        }
        return ChatCollectionViewLayoutModel.createModel(self.collectionView.bounds.width, itemsLayoutData: layoutData)
    }

}

let dateFormater = NSDateFormatter()

private func createTextViewModel(text: String) -> TextMessageViewModel {
    let messageViewModel = MessageViewModel(dateFormatter: dateFormater, showsTail: false, avatarImage: nil)
    let viewModel = TextMessageViewModel(text: text, messageViewModel: messageViewModel)
    return viewModel
}

public protocol UniqueIdentificable {
    var uid: String { get }
}

public struct CollectionChangeMove: Equatable, Hashable {
    public let indexPathOld: NSIndexPath
    public let indexPathNew: NSIndexPath
    public init(indexPathOld: NSIndexPath, indexPathNew: NSIndexPath) {
        self.indexPathOld = indexPathOld
        self.indexPathNew = indexPathNew
    }

    public var hashValue: Int { return indexPathOld.hash ^ indexPathNew.hash }
}

public func == (lhs: CollectionChangeMove, rhs: CollectionChangeMove) -> Bool {
    return lhs.indexPathOld == rhs.indexPathOld && lhs.indexPathNew == rhs.indexPathNew
}

public struct CollectionChanges {
    public let insertedIndexPaths: Set<NSIndexPath>
    public let deletedIndexPaths: Set<NSIndexPath>
    public let movedIndexPaths: [CollectionChangeMove]

    init(insertedIndexPaths: Set<NSIndexPath>, deletedIndexPaths: Set<NSIndexPath>, movedIndexPaths: [CollectionChangeMove]) {
        self.insertedIndexPaths = insertedIndexPaths
        self.deletedIndexPaths = deletedIndexPaths
        self.movedIndexPaths = movedIndexPaths
    }
}

func generateChanges(oldCollection oldCollection: [UniqueIdentificable], newCollection: [UniqueIdentificable]) -> CollectionChanges {
    func generateIndexesById(uids: [String]) -> [String: Int] {
        var map = [String: Int](minimumCapacity: uids.count)
        for (index, uid) in uids.enumerate() {
            map[uid] = index
        }
        return map
    }

    let oldIds = oldCollection.map { $0.uid }
    let newIds = newCollection.map { $0.uid }
    let oldIndexsById = generateIndexesById(oldIds)
    let newIndexsById = generateIndexesById(newIds)
    var deletedIndexPaths = Set<NSIndexPath>()
    var insertedIndexPaths = Set<NSIndexPath>()
    var movedIndexPaths = [CollectionChangeMove]()

    // Deletetions
    for oldId in oldIds {
        let isDeleted = newIndexsById[oldId] == nil
        if isDeleted {
            deletedIndexPaths.insert(NSIndexPath(forItem: oldIndexsById[oldId]!, inSection: 0))
        }
    }

    // Insertions and movements
    for newId in newIds {
        let newIndex = newIndexsById[newId]!
        let newIndexPath = NSIndexPath(forItem: newIndex, inSection: 0)
        if let oldIndex = oldIndexsById[newId] {
            if oldIndex != newIndex {
                movedIndexPaths.append(CollectionChangeMove(indexPathOld: NSIndexPath(forItem: oldIndex, inSection: 0), indexPathNew: newIndexPath))
            }
        } else {
            // It's new
            insertedIndexPaths.insert(newIndexPath)
        }
    }

    return CollectionChanges(insertedIndexPaths: insertedIndexPaths, deletedIndexPaths: deletedIndexPaths, movedIndexPaths: movedIndexPaths)
}

