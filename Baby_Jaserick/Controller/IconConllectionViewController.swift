//
//  IconConllectionViewController.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/24/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit

protocol IconPickingDelegate {
    func pickIcon(selectedIcon: UIImage)
}

class IconConllectionViewController: UIViewController {
    
    @IBOutlet weak var iconCollectionView: UICollectionView!
    
    var imageListName: [String] = []
    
    
    var iconPickingDelegate: IconPickingDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchImageNameInArray()
        self.adjustPadding()
    }
    
    private func adjustPadding() {
        let layout = self.iconCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        let width = (self.iconCollectionView.frame.width - 20) / 7
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    private func fetchImageNameInArray() {
        for index in 1 ... 71 {
            imageListName.append(String(format: "icon%i", index))
        }
    }

}

extension IconConllectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageListName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = iconCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.iconCell, for: indexPath) as! IconCollectionViewCell
        cell.iconImage = UIImage(named: imageListName[indexPath.item])
        return cell
    }
}

extension IconConllectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.iconPickingDelegate?.pickIcon(selectedIcon: UIImage(named: imageListName[indexPath.item])!)
        dismiss(animated: true, completion: nil)
    }
}
