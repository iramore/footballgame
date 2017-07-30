//
//  PauseMenuViewController.swift
//  Footballgame
//
//  Created by infuntis on 08/07/17.
//  Copyright © 2017 gala. All rights reserved.
//

import Foundation
import UIKit

class ShopMenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    let reuseIdentifier = "cell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate  = self
        let numberOfCell:CGFloat = 2.0
        let cellSpecing:CGFloat = 10.0
        //let screenSize = UIScreen.main.bounds
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            let width = (collectionView.bounds.width - (cellSpecing * (numberOfCell + 1))) / numberOfCell
//            collectionView.collectionViewLayout.itemSize = CGSize(width: width, height: width*1.5)
//            layout.invalidateLayout()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(ThemeBall.count)
        return ThemeBall.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let theWidth = (collectionView.bounds.width - (10*3))/2
        let theHeight = theWidth*1.5
        return CGSize(width: theWidth ,height: theHeight)
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
//    {
//        let cellSpacing = CGFloat(2) //Define the space between each cell
//        let leftRightMargin = CGFloat(20) //If defined in Interface Builder for "Section Insets"
//        let numColumns = CGFloat(3) //The total number of columns you want
//        
//        let totalCellSpace = cellSpacing * (numColumns - 1)
//        let screenWidth = UIScreen.mainScreen().bounds.width
//        let width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
//        let height = CGFloat(110) //whatever height you want
//        
//        return CGSizeMake(width, height);
//    }
    
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ShopCellViewController
        if let value = ThemeBall(rawValue: indexPath.item) {
            cell.iamge.image = UIImage(named: "ball_\(value.string)_for_shop")
            //cell.backgroundColor = UIColor.blue
            //cell.label.text = value.string
        }
        
        
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 2
    }
//     func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.backgroundColor = UIColor.red
//    }
    
   
     func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        //cell?.backgroundColor = UIColor.cyan
        NSLog("You selected cell number: \(indexPath.item)!")
        UserDefaults.standard.setValue(indexPath.item, forKey: SelectedBallKey)
        dismiss(animated: true, completion: nil)
    }

}

class ShopCellViewController : UICollectionViewCell{
    
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var iamge: UIImageView!
}
