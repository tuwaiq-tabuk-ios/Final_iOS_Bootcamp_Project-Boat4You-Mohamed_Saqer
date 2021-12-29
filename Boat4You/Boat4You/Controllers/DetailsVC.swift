//
//  DetailsVC.swift
//  Boat4You
//
//  Created by Mohammed on 24/05/1443 AH.
//

import UIKit
class DetailsVC: UIViewController {
    
    
    
    
    
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var captainName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productDescription: UILabel!
   
    var store:Store!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        captainName.text = store.productName
        location.text = store.selectCity
        type.text = store.selectType
        price.text = store.price
        productDescription.text = store.productDescription
    }
}
