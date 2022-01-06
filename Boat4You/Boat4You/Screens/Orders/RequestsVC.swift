//
//  RequestsVC.swift
//  Boat4You
//
//  Created by Mohammed on 30/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class RequestsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
  
  @IBOutlet weak var ordersCollectionView: UICollectionView!

  let radius: CGFloat = 8
  var request: RequestCVCell!
  var orders: [Order] = [Order]()
  override func viewDidLoad() {
    super.viewDidLoad()
    ordersCollectionView.delegate = self
    ordersCollectionView.dataSource = self
    //      request.requestView.dropShadow(radius:radius , opacity: 0.2, color: .black)
  }
  
  
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reciveData()
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return orders.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestsCell", for: indexPath) as! RequestCVCell
    
    cell.titleLabel.text = orders[indexPath.row].phoneNumner
    cell.dateLabel.text = orders[indexPath.row].dateUploaded
      return cell
    
  }
  
  
  
  
  
  func reciveData() {
    let db = Firestore.firestore()
    let auth = Auth.auth().currentUser
    var ID = ""
    db.collection("stores").document(auth!.uid).collection("store").getDocuments { snapshot, error
      in if error != nil {
        
      } else {
        
        for document in snapshot! .documents {
          let data = document.data()
          
          ID = data["id"] as! String
          let collectionRF:CollectionReference = db.collection("orders")
          collectionRF.getDocuments { [self] snapshot, error in
            if error != nil {
            } else {
              orders.removeAll()
              for document in snapshot!.documents {
                let allData = document.data()
                if document.documentID == ID {
                  for ( _ ,value) in allData {
                    
                    let data = value as! Dictionary<String,Any>
                    
                    let gettingInfo = Order(phoneNumner: data ["phoneNumber"] as!String,
                                             dateUploaded: data ["dateTextField"] as!String)
                    
                    
                    orders.append(gettingInfo)
                    ordersCollectionView.reloadData()
                    print("~~\(gettingInfo)")
                  }
                }
              }
            }
          }
          
        }
      }
    }
  }
}
