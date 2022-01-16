//
//  CollectionSecondPageVC.swift
//  Boaty
//
//  Created by Mohammed on 15/05/1443 AH.
//

import UIKit

class OffersCollectionVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
   
 
  @IBOutlet weak var storeCollection: UICollectionView!
  @IBOutlet weak var search: UISearchBar!
  var array:[Store]!
  var storeSelected:Store!

    
  override func viewDidLoad() {
      super.viewDidLoad()
      storeCollection.delegate = self
      storeCollection.dataSource = self
  }
  
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell2", for: indexPath) as! StoreCVCell
       
        cell.boatsImageView.sd_setImage(with: URL(string: array[indexPath.row].logo), placeholderImage: UIImage(named: "Craft"))
        cell.nameLabel.text = array[indexPath.row].productName
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
