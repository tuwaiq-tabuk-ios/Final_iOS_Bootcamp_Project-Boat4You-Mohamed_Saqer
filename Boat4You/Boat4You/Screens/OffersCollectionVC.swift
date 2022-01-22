//
//  CollectionSecondPageVC.swift
//  Boaty
//
//  Created by Mohammed on 15/05/1443 AH.
//

import UIKit

class OffersCollectionVC: UIViewController,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          UICollectionViewDelegateFlowLayout {
   
  //MARK: - IBAction
  @IBOutlet weak var storeCollection: UICollectionView!
  var array:[Store]!
  var storeSelected:Store!

  
  //MARK: - View Controller lifecycle
  override func viewDidLoad() {
      super.viewDidLoad()
      storeCollection.delegate = self
      storeCollection.dataSource = self
  }
  
  
  //MARK: - UICollection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell2", for: indexPath) as! StoreCVCell
       
        cell.storeOfferImage.sd_setImage(with: URL(string: array[indexPath.row].logo), placeholderImage: UIImage(named: "PlaceHolder"))
        cell.titleLabel.text = array[indexPath.row].title
        cell.priceLabel.text = array[indexPath.row].price
        return cell
    }
    
  
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        storeSelected = array[indexPath.row]
        return true
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? DetailsVC {
            
            vc.store = storeSelected
        }
    }
}
