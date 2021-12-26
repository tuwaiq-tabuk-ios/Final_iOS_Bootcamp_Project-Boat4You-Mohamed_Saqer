//
//  ViewController.swift
//  Boot4You
//
//  Created by Mohammed on 08/05/1443 AH.
//

import UIKit

struct Section {
    let name:String
    let image:UIImage
    let stores:[Store]
}

class MainVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
   
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView:UICollectionView!
    
//    @IBOutlet weak var startingImage: UIImageView!
//    
    
    var selectedSection:[Store]!
    
    var array:[Section] = [
        Section(name: "Craft",
                image: UIImage(named: "Craft")!,
                stores: [
                    Store(name: "Craft", image: UIImage(named: "Craft")!, price: "$50"),
                    Store(name: "Craft", image: UIImage(named: "Craft")!, price: "$40"),
                    Store(name: "Craft", image: UIImage(named: "Craft")!, price: "$30"),
                    Store(name: "Craft", image: UIImage(named: "Craft")!, price: "$15"),
                ]),
        Section(name: "Sailing",
                image: UIImage(named: "Sailing")!,
                stores: [
                Store(name: "Sailing", image: UIImage(named: "Sailing")!, price: "$50"),
                Store(name: "Sailing", image: UIImage(named: "Sailing")!, price: "$40"),
                Store(name: "Sailing", image: UIImage(named: "Sailing")!, price: "$30"),
                Store(name: "Sailing", image: UIImage(named: "Sailing")!, price: "$15"),
            ]),
        
        
        Section(name: "Diving",
                image: UIImage(named: "Diving")!,
                stores: [
                Store(name: "Diving", image: UIImage(named: "Diving")!, price: "$50"),
                Store(name: "Diving", image: UIImage(named: "Diving")!, price: "$40"),
                Store(name: "Diving", image: UIImage(named: "Diving")!, price: "$30"),
                Store(name: "Diving", image: UIImage(named: "Diving")!, price: "$15"),
            ])
    ]
   
    
    
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as! CollectionVC
       
        cell.imageView.image = array[indexPath.row].image
        cell.labelView.text = array[indexPath.row].name
        return cell
    }
    
//    let searchBar = UISearchBar()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
       
        
        
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.backgroundColor = UIColor.white
        searchBar.searchTextField.backgroundColor = UIColor.white
        
//        searchBar.barTintColor = UIColor.clear
//        searchBar.backgroundColor = UIColor.clear
        
//        searchBar.isTranslucent = true
        
//        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .disabled)
//        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedSection = array[indexPath.row].stores
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StoreCollectionVC {
            vc.array = selectedSection
        }
    }
    
       
    }

