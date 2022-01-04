//
//  TableCellTableViewCell.swift
//  Boat4You
//
//  Created by Mohammed on 27/05/1443 AH.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

  @IBOutlet weak var OrderLogoImage: UIImageView!
  @IBOutlet weak var orderPrice: UILabel!
  @IBOutlet weak var orderDate: UILabel!
  @IBOutlet weak var orderCaptainName: UILabel!
 
  override func awakeFromNib() {
        super.awakeFromNib()
    }
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

  
  
  @IBAction func cancelButtonPressed(_ sender: UIButton) {
  }
  
  
  
}
