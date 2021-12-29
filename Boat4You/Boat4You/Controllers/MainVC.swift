//
//  ViewController.swift
//  Boot4You
//
//  Created by Mohammed on 08/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

struct Section {
    let name:String
    let image:String
    let stores:[Store]
}

class MainVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView:UICollectionView!
    
    //    @IBOutlet weak var startingImage: UIImageView!
    //
    
    var selectedSection:[Store]!
    
    var array:[Section] = [Section]()
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as! CollectionVC
        
        cell.imageView.sd_setImage(with: URL(string: array[indexPath.row].image), placeholderImage: UIImage(named: "Craft"))
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
        
        
        //        Section(name: "Craft",
        //                image: UIImage(named: "Craft")!,
        //                stores: [
        //                ]),
        //        Section(name: "Sailing",
        //                image: UIImage(named: "Sailing")!,
        //                stores: [
        //            ]),
        //
        //
        //        Section(name: "Diving",
        //                image: UIImage(named: "Diving")!,
        //                stores: [
        //            ])
        //    ]
        
        let db = Firestore.firestore()
        let auth = Auth.auth().currentUser
        
        let collectionRF:CollectionReference = db.collection("sections")
        
        
        collectionRF.getDocuments { snapshot, error in
            if error != nil {
                
            } else {
                
                for document in snapshot!.documents {
                    let datas = document.data()
                    if document.documentID == "craft" {
                        var arrayStore = [Store]()
                        for (key,value) in datas {
                            let data = value as! Dictionary<String,Any>
                            
                            arrayStore.append(Store(id: key, productName: data["productName"] as! String,
                                                    logo: data["logo"] as! String,
                                                    price: data["price"] as! String,
                                                    images: data["images"] as! Array,
                                                    productDescription: data["productDescription"] as! String,
                                                    selectCity: data["selectCity"] as! String,
                                                    selectType: data["selectType"] as! String))
                        }
                        
                        self.array.append(
                            Section(name: document.documentID,
                                    image: "" ,
                                    stores: arrayStore))
                        
                        
                    } else if document.documentID == "boat"{
                        var arrayStore = [Store]()
                        for (key,value) in datas {
                            let data = value as! Dictionary<String,Any>
                            
                            arrayStore.append(Store(id: key, productName: data["productName"] as! String,
                                                    logo: data["logo"] as! String,
                                                    price: data["price"] as! String,
                                                    images: data["images"] as! Array,
                                                    productDescription: data["productDescription"] as! String,
                                                    selectCity: data["selectCity"] as! String,
                                                    selectType: data["selectType"] as! String))
                        }
                        
                        self.array.append(
                            Section(name: document.documentID,
                                    image: "" ,
                                    stores: arrayStore))
                    }
                    
                    
                }
                self.collectionView.reloadData()
                
                
            }
        }
        
        
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

