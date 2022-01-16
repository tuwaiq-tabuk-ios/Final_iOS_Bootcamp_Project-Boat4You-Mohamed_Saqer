//
//  RequestsVC.swift
//  Boat4You
//
//  Created by Mohammed on 30/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth

class RequestsVC: UIViewController,
                  UICollectionViewDelegate,
                  UICollectionViewDataSource {
  
  @IBOutlet weak var ordersCollectionView: UICollectionView!
  
  let radius: CGFloat = 8
  var request: RequestCVCell!
  var orders: [Order] = [Order]()
  override func viewDidLoad() {
    super.viewDidLoad()
    ordersCollectionView.delegate = self
    ordersCollectionView.dataSource = self
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
    cell.deleteRequest.tag = indexPath.row
    return cell
  }
  

  @IBAction func deletRequestPressed(_ sender: UIButton) {
   
    let index = sender.tag
      
     let ind2 = orders.firstIndex(of: orders[index])
      let db = Firestore.firestore()
    db.collection("orders").document(orders[index].docID).delete()
   
    orders.remove(at: ind2!)
    ordersCollectionView.reloadData()
  }
  
  
  func reciveData() {
    let db = Firestore.firestore()
    db.collection("orders").addSnapshotListener { (querySnapshot, error) in
            
            if let error = error {
                print("There was problem of getting data. \(error)")
            } else {

                self.orders = []
                
                for document in querySnapshot!.documents{
                    let data = document.data()

                    self.orders.append(
                        Order(
                    
                      phoneNumner: data["phoneNumber"] as? String ?? "SS",
                      dateUploaded: data ["date"] as? String ?? "SS",
                      docID: data ["docID"] as? String ?? "SS",
                      orderID: data ["id"] as? String ?? "SS"
                    
                    )
                )}
                DispatchQueue.main.async {

                    self.ordersCollectionView.reloadData()
                    
                }
                
            }
        }
    }
}
