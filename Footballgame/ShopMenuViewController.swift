//
//  PauseMenuViewController.swift
//  Footballgame
//
//  Created by infuntis on 08/07/17.
//  Copyright © 2017 gala. All rights reserved.
//

import Foundation
import UIKit

class ShopMenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    let reuseIdentifier = "cell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ThemeBall.count
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ShopCellViewController
        if let value = ThemeBall(rawValue: indexPath.item) {
            cell.iamge.image = UIImage(named: "ball_\(value.string)")
            //cell.label.text = value.string
        }
        
        
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 2
    }
     func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.red
    }
    
   
     func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.cyan
        UserDefaults.standard.setValue(indexPath.item, forKey: SelectedBallKey)
    }

}

class ShopCellViewController : UICollectionViewCell{
    
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var iamge: UIImageView!
}
