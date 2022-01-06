//
//  CollectionSecondPageVC.swift
//  Boaty
//
//  Created by Mohammed on 15/05/1443 AH.
//

import UIKit

class OffersCollectionVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
   
   
    var array:[Store]!
    var storeSelected:Store!
//    var array:[Store] = [
//        Store(name: "Craft", image: UIImage(named: "Craft")!, price: "$50"),
//        Store(name: "Sailing", image: UIImage(named: "Sailing")!, price: "$40"),
//        Store(name: "Diving", image: UIImage(named: "Diving")!, price: "$30"),
//        Store(name: "Diving", image: UIImage(named: "Diving")!, price: "$15"),
//    ]
    
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
    
//    @IBAction func backTapped(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    
   
  
    
    @IBOutlet weak var storeCollection: UICollectionView!
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? DetailsVC {
            
            vc.store = storeSelected
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeCollection.delegate = self
        storeCollection.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
