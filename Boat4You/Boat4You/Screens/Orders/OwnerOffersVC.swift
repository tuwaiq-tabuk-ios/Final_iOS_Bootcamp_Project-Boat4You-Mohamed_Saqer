//
//  OwnerOrdersVC.swift
//  Boat4You
//
//  Created by Mohammed on 30/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage
import FirebaseFirestore

class OwnerOffersVC: UIViewController,
                     UICollectionViewDelegate,
                     UICollectionViewDataSource {
  
  // MARK: - IBOutlet
  @IBOutlet weak var collectionViewE: UICollectionView!
  @IBOutlet weak var stopTouchView: UIView!
  
  // MARK: -Properties
  var store = [Store]()
  var storeSelected:Store!
  var dataFilter: [Section]!
  var collectionRF: CollectionReference!
  let radius: CGFloat = 8
  
  // MARK: - View Controller lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionViewE.delegate = self
    collectionViewE.dataSource = self
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser!
    collectionRF = db.collection("stores").document(auth.uid).collection("store")
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    stopTouchView.isUserInteractionEnabled = false
    getData()
  }
  
  // MARK: - IBAction
  @IBAction func removeCVPressed(_ sender: UIButton) {
    let index = sender.tag
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    let storeID = store[index].id
    let storeType = store[index].selectType.lowercased()
    db.collection("stores").document(userID!).collection("store").document(storeID).delete()
    let documentRef = db.collection("sections").document(storeType)
    documentRef.updateData([storeID:FieldValue.delete()]) { error in
      guard error == nil else {return}
      
      self.store.remove(at: index)
      self.collectionViewE.reloadData()
    }
  }
  
  
  @IBAction func editButtonPressed(_ sender: UIButton) {
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditOwnerInfoVC") as! EditOwnerInfoVC
    
    nextViewController.store = store[sender.tag]
    self.navigationController?.pushViewController(nextViewController, animated: true)
  }
  
  
  // MARK: - Collection methods
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return store.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrdersCell", for: indexPath) as! OwnerOrderCVCell
    
    cell.orderImage.sd_setImage(with: URL(string: store[indexPath.row].logo),
                                placeholderImage: UIImage(named: "Craft"))
    
    cell.orderTitle.text = store[indexPath.row].captainName
    cell.orderPrice.text = store[indexPath.row].price
    cell.editButoon.tag = indexPath.row
    cell.removeCV.tag = indexPath.row
    print("~~ gg")
    return cell
  }
  
  
  // MARK: - Method
  func getData() {
    
    let db = Firestore.firestore()
    
    collectionRF.getDocuments { snapshot, error in
      if error != nil {
        print("-----error get data: \(String(describing: error?.localizedDescription))")
        
      } else {
        self.store.removeAll()
        
        for document in snapshot!.documents {
          let datas = document.data()
          
          db.collection("sections")
            .document(datas["type"] as! String)
            .getDocument { document, error in
              if error != nil {
                
              } else {
                let data = document?.data()
                for (key, value) in data! {
                  if key == datas["id"] as! String {
                    let dic = value as! Dictionary<String,Any>
                    let store1 = Store(id:   key,
                                       captainName     :dic["productName"]        as! String,
                                       logo            :dic["logo"]               as! String,
                                       price           :dic["price"]              as! String,
                                       images          :dic["images"]             as! Array,
                                       offerDescription:dic["productDescription"] as! String,
                                       selectCity      :dic["selectCity"]         as! String,
                                       selectType      :dic["selectType"]         as! String,
                                       title           :dic["title"]              as! String)
                    
                    self.store.append(store1)
                    self.collectionViewE.reloadData()
                    self.stopTouchView.isUserInteractionEnabled = true
                }
              }
            }
          }
        }
      }
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let vc = segue.destination as? EditOwnerInfoVC {
      vc.store = storeSelected
    }
  }
}



