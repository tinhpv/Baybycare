//
//  IconCollectionViewController.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/24/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class IconCollectionViewController: UICollectionViewController {
    
    var imageListName: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchImageNameInArray()
        self.adjustLayoutCollection()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    private func adjustLayoutCollection() {
        let collectionViewWidth = collectionView.frame.width
        let leftAndRightPaddings = CGFloat(exactly: 5.0)
        let itemWidth = (collectionViewWidth - leftAndRightPaddings!) / 8.0
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    
    private func fetchImageNameInArray() {
        for index in 1 ... 29 {
            imageListName.append(String(format: "icon%i", index))
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageListName.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.iconCell, for: indexPath) as! IconCollectionViewCell
    
        cell.iconImage = UIImage(named: imageListName[indexPath.row])
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
