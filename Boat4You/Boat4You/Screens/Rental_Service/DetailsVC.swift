//
//  DetailsVCViewController.swift
//  Boat4You
//
//  Created by Mohammed on 25/05/1443 AH.
//

import UIKit

class DetailsVC: UIViewController,
                 UICollectionViewDelegate,
                 UICollectionViewDataSource {
  
  // MARK: - IBoutlet
  @IBOutlet weak var bookingButtonOutlet  : UIButton!
  @IBOutlet weak var detailsView          : UIView!
  @IBOutlet weak var descriptionLabel     : UILabel!
  @IBOutlet weak var storeCV              : UICollectionView!
  @IBOutlet weak var captainNameLabel     : UILabel!
  @IBOutlet weak var locationLabel        : UILabel!
  @IBOutlet weak var typeLabel            : UILabel!
  @IBOutlet weak var priceLabel           : UILabel!
  @IBOutlet weak var offerDescriptionLabel: UILabel!
  @IBOutlet weak var titleLabel           : UILabel!
  
  // MARK: - Properties
  let radius: CGFloat = 8
  var store:Store!

  
  // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        detailsView.dropShadow(radius: radius, opacity: 0.2, color: .black)
//      bookingButtonOutlet.dropShadow(radius: radius, opacity: 0.2, color: .black)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text            =      store.title
        captainNameLabel.text      =      store.captainName
        locationLabel.text         =      store.selectCity
        typeLabel.text             =      store.selectType
        priceLabel.text            =      store.price
        offerDescriptionLabel.text =      store.offerDescription
    }
    
  
  // MARK: - Collection methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.images.count
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! StoreImageCVCell
        
        cell.storeImages.sd_setImage(with: URL(string: store.images[indexPath.row]), placeholderImage: UIImage(named: "Craft"))
        return cell
    }
    
  // MARK: - Prepare
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? ClientBookVC {
      vc.dataRequested = store
    }
  }
}


