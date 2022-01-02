//
//  TableCellTableViewCell.swift
//  Boat4You
//
//  Created by Mohammed on 27/05/1443 AH.
//

import UIKit

class TableCellTableViewCell: UITableViewCell {

  
  
  
  
  
  @IBOutlet weak var viewDetails: UIView!
  @IBOutlet weak var OrderLogoImage: UIImageView!
  @IBOutlet weak var orderPrice: UILabel!
  @IBOutlet weak var orderDate: UILabel!
  @IBOutlet weak var orderCaptainName: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  
  
  @IBAction func cancelButtonPressed(_ sender: UIButton) {
  }
  
  
  
}
