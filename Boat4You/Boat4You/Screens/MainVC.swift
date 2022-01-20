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
import FirebaseFirestore

class MainVC: UIViewController {
  
  //MARK: - IBOutlet
  
  @IBOutlet weak var collectionView:UICollectionView!
  
  //MARK: - Properties
  
  var selectedSection:[Store]!
  var array:[Section] = [Section]()
  let radius: CGFloat = 8
  var dataFilter: [Store]!
  
  
  //MARK: - View Controller lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
    getDataFromFireStore()
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? OffersCollectionVC {
      vc.array = selectedSection
    }
  }
  
  
  //MARK: - Methods
  func getDataFromFireStore() {
    
    let db = Firestore.firestore()
    
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
              
              arrayStore.append(Store(id: key, captainName: data["captainName"] as! String,
                                      logo: data["logo"] as! String,
                                      price: data["price"] as! String,
                                      images: data["images"] as! Array,
                                      offerDescription: data["productDescription"] as! String,
                                      selectCity: data["selectCity"] as! String,
                                      selectType: data["selectType"] as! String,
                                      title: data["title"] as! String))
            }
            
            self.array.append(
              Section(name: document.documentID,
                      image: "" ,
                      stores: arrayStore))
            
            
          } else if document.documentID == "boat"{
            var arrayStore = [Store]()
            for (key,value) in datas {
              let data = value as! Dictionary<String,Any>
              
              arrayStore.append(Store(id: key, captainName: data["captainName"] as! String,
                                      logo: data["logo"] as! String,
                                      price: data["price"] as! String,
                                      images: data["images"] as! Array,
                                      offerDescription: data["productDescription"] as! String,
                                      selectCity: data["selectCity"] as! String,
                                      selectType: data["selectType"] as! String,
                                      title: data["title"] as! String))
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
}


//MARK: - Collection View
extension MainVC: UICollectionViewDelegate,
                  UICollectionViewDataSource,
                  UICollectionViewDelegateFlowLayout {
                    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                      return array.count
                    }
                    
                    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as! CollectionVC
                      
          cell.imageView.sd_setImage(with: URL(string: array[indexPath.row].image), placeholderImage: UIImage(named: "Item"))
                      
          cell.labelView.text = array[indexPath.row].name
                        return cell
                    }
       
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
                      selectedSection = array[indexPath.row].stores
                      return true
                    }
                  }
