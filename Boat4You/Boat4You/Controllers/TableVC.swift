//
//  TableVC.swift
//  Boat4You
//
//  Created by Mohammed on 27/05/1443 AH.
//

import UIKit

class TableVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
  
  

 
  let radius: CGFloat = 8
 
  

  
  
  override func viewDidLoad() {
        super.viewDidLoad()

      tableView.delegate = self
      tableView.dataSource = self
    tableView.dropShadow(radius: radius, opacity: 0.2, color: .black)
//    dgkd.dropShadow(radius: radius, opacity: 0.2, color: .black)
    }
    
  
  @IBOutlet weak var tableView: UITableView!
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseCell", for: indexPath) as! TableCellTableViewCell
//    cell.OrderLogoImage.image = UIImage(named: "")
//    cell.orderCaptainName.text = "String"
    
    
    return cell
  }

}
