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
import SwiftUI
class OwnerOrdersVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
 
  var store = [Store]()
  var collectionRF: CollectionReference!
  let radius: CGFloat = 8
    override func viewDidLoad() {
        super.viewDidLoad()
      collectionView.delegate = self
      collectionView.dataSource = self
//      collectionView.dropShadow(radius: radius , opacity: 0.5, color: .black)
    }
  @IBOutlet weak var collectionView: UICollectionView!
  
  
  
    
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrdersCell", for: indexPath) as! OwnerOrdersCollectionViewCell
//    cell.orderImage.image = UIImage(named: "BoatMain")
//    cell.orderTitle.text = "String"
//    cell.orderDate.text = "String"
//    cell.orderPrice.text = "String"
    return cell
  }
  
  
  
  func getData() {
    
    collectionRF.getDocuments { snapshot, error in
       if error != nil {
        print("~~ error get data: \(error?.localizedDescription)")
       } else {
        self.store.removeAll()
        
         
         for document in snapshot!.documents {
         let data = document.data()
        
          for document in snapshot!.documents {
              let datas = document.data()
              if document.documentID == "craft" {
                  var arrayStore = [Store]()
          for (key,value) in datas {
              let data = value as! Dictionary<String,Any>
          
          let store1 = Store(id: key, productName: data["productName"] as! String,
                           logo: data["logo"] as! String,
                           price: data["price"] as! String,
                           images: data["images"] as! Array,
                           productDescription: data["productDescription"] as! String,
                           selectCity: data["selectCity"] as! String,
                           selectType: data["selectType"] as! String,
                           title: data["title"] as! String)
          
         print("\n\n # # # # # #\(#file) - \(#function)")
          print("id: data[id]: \(data["id"] as! String)")
         print(" - data[images] as? [String]: \(String(describing: data["images"] as? [String]))")
         self.store.append(store1)
        }
//         var id:String
//         var productName: String
//         var logo: String
//         var price: String
//         var images:[String]
//         var productDescription: String
//         var selectCity: String
//         var selectType: String
//       var title: String
       }
       self.collectionView.reloadData()
      }
     }
    }
  
    }
  }
  
}
