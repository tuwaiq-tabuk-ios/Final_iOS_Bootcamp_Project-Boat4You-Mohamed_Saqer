//
//  DetailsVCViewController.swift
//  Boat4You
//
//  Created by Mohammed on 25/05/1443 AH.
//

import UIKit

class DetailsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
  

   

   
  @IBOutlet weak var bookingButtonOutlet: UIButton!
  @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var descriptionView: UILabel!
    @IBOutlet weak var storeCollection: UICollectionView!
    @IBOutlet weak var captainName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
  
    let radius: CGFloat = 8
    var store:Store!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsView.dropShadow(radius: radius, opacity: 0.2, color: .black)
      bookingButtonOutlet.dropShadow(radius: radius, opacity: 0.2, color: .black)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
      titleLabel.text = store.title
        captainName.text = store.productName
        location.text = store.selectCity
        type.text = store.selectType
        price.text = store.price
        productDescription.text = store.productDescription
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! StoreImages
        
        cell.storeImages.sd_setImage(with: URL(string: store.images[indexPath.row]), placeholderImage: UIImage(named: "Craft"))
        return cell
        
    }
    
  
  @IBAction func bookingButtonTapped(_ sender: UIButton) {
  
  
  }
  
}


