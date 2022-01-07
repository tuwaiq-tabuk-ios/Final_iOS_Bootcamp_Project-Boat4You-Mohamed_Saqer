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
class OwnerOrdersVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
  
  @IBOutlet weak var collectionViewE: UICollectionView!
  var store = [Store]()
  var storeSelected:Store!
  var dataFilter: [Section]!
  var collectionRF: CollectionReference!
  let radius: CGFloat = 8
  
    override func viewDidLoad() {
        super.viewDidLoad()
      collectionViewE.delegate = self
      collectionViewE.dataSource = self
//      collectionView.dropShadow(radius: radius , opacity: 0.5, color: .black)
         let db = Firestore.firestore()
      let auth = Auth.auth().currentUser!
      collectionRF = db.collection("stores").document(auth.uid).collection("store")
      
    }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.isUserInteractionEnabled = false
    getData()
    
   }
  
  
    
  @IBAction func editButtonPreased(_ sender: UIButton) {
    
//    storeSelected = store[sender.tag]
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditOwnerInfoVC") as! EditOwnerInfoVC
    
    nextViewController.store = store[sender.tag]
    self.navigationController?.pushViewController(nextViewController, animated: true)
    
  }
  
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
    
    cell.orderTitle.text = store[indexPath.row].productName
    cell.orderPrice.text = store[indexPath.row].price
    cell.editButoon.tag = indexPath.row
    print("~~ gg")
    return cell
  }
  
  
  
//  @IBAction func removeCollection(_ sender: UIButton) {
////    let index = sender.tag
////      let ind = dataFilter.firstIndex(of: dataFilter[index])
////     let ind2 = arrCafe.firstIndex(of: dataFilter[index])
////      let db = Firestore.firestore()
////      db.collection("sections").document(filterdata[index].id).delete()
////    dataFilter.remove(at: ind!)
////      arrCafe.remove(at: ind2!)
////      collectionCafe.reloadData()
//  }
  
  
  func getData() {
    let db = Firestore.firestore()

    collectionRF.getDocuments { snapshot, error in
       if error != nil {
        print("~~ error get data: \(error?.localizedDescription)")
       } else {
        self.store.removeAll()
        
         
         for document in snapshot!.documents {
              let datas = document.data()
            
           db.collection("sections").document(datas["type"] as! String).getDocument { document, error in
             if error != nil {
               
             } else {
               let data = document?.data()
               for (key, value) in data! {
                 if key == datas["id"] as! String {
                   let dic = value as! Dictionary<String,Any>
                 let store1 = Store(id: key, productName: dic["productName"] as! String,
                                  logo: dic["logo"] as! String,
                                  price: dic["price"] as! String,
                                  images: dic["images"] as! Array,
                                  productDescription: dic["productDescription"] as! String,
                                  selectCity: dic["selectCity"] as! String,
                                  selectType: dic["selectType"] as! String,
                                  title: dic["title"] as! String)

                self.store.append(store1)
                   self.collectionViewE.reloadData()
                   self.view.isUserInteractionEnabled = true
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



