//
//  RequestsVC.swift
//  Boat4You
//
//  Created by Mohammed on 30/05/1443 AH.
//

import UIKit

class RequestsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

  let radius: CGFloat = 8
  var request: RequestsCollectionViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
      collectionView.delegate = self
      collectionView.dataSource = self
//      request.requestView.dropShadow(radius:radius , opacity: 0.2, color: .black)
    }
    

  @IBOutlet weak var collectionView: UICollectionView!
 
  
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestsCell", for: indexPath) as! RequestsCollectionViewCell
    cell.requestImage.image = UIImage(named: "BoatMain")
    cell.titleLabel.text = "String"
    cell.priceLabel.text = "String"
    cell.dateLabel.text = "String"
    return cell
  }

}
