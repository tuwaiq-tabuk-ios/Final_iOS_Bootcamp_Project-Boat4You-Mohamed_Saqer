//
//  RequestsVC.swift
//  Boat4You
//
//  Created by Mohammed on 30/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class GetOffersVC: UIViewController,
                  UICollectionViewDelegate,
                  UICollectionViewDataSource {
  
  // MARK: - IBOutlet
  @IBOutlet weak var ordersCollectionView: UICollectionView!
  
  // MARK: -Properties
  let radius: CGFloat = 8
  var request: RequestCVCell!
  var orders: [Order] = [Order]()
  
  // MARK: -View Controller Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    ordersCollectionView.delegate = self
    ordersCollectionView.dataSource = self
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    receiveOfferFromClient()
  }
  
  
  // MARK: - IBAction
  @IBAction func deletRequestPressed(_ sender: UIButton) {
    let index = sender.tag
    
    let ind2 = orders.firstIndex(of: orders[index])
    let db = Firestore.firestore()
    db.collection("orders").document(orders[index].docID).delete()
    
    orders.remove(at: ind2!)
    ordersCollectionView.reloadData()
  }
  
  
  // MARK: - Recieve offer method
  func receiveOfferFromClient() {
    
    let db = Firestore.firestore()
    let userID = Auth.auth().currentUser?.uid
    
    db.collection("stores").document(userID!).collection("store").getDocuments { snapshot, error in
      guard error == nil else {return}
      
      guard let document = snapshot?.documents else {return}
      
      for documentSnapshot in document {
        let id = documentSnapshot.documentID
        db.collection("orders").whereField("id", isEqualTo: id).addSnapshotListener { (querySnapshot, error) in
          if let error = error {
            print("There was a problem of getting data. \(error)")
          
          } else {
            self.orders = []
            for document in querySnapshot!.documents{
            let data = document.data()
            self.orders.append(
               
              Order(
                  phoneNumner:  data["phoneNumber"] as? String ?? "SS",
                  dateUploaded: data ["date"]       as? String ?? "SS",
                  docID:        data ["docID"]      as? String ?? "SS",
                  orderID:      data ["id"]         as? String ?? "SS"
                )
              )}
           
            DispatchQueue.main.async {
              self.ordersCollectionView.reloadData()
            }
          }
        }
      }
    }
  }
  // MARK: -Collection View methods
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return orders.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestsCell", for: indexPath) as! RequestCVCell
    
    cell.titleLabel.text = orders[indexPath.row].phoneNumner
    cell.dateLabel.text = orders[indexPath.row].dateUploaded
    cell.deleteRequest.tag = indexPath.row
    return cell
  }
}
