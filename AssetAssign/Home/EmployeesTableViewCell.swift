//
//  EmployeesTableViewCell.swift
//  AssetAssign
//
//  Created by Moin Janjua on 19/08/2024.
//

import UIKit

class EmployeesTableViewCell: UITableViewCell {

    @IBOutlet weak var cView: UIView!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var additems_btn: UIButton!
    @IBOutlet weak var downArrow_btn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cView.layer.cornerRadius = 12
        // Set up shadow properties
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cView.layer.shadowOpacity = 0.3
        cView.layer.shadowRadius = 4.0
        cView.layer.masksToBounds = false
        // Set background opacity
        cView.alpha = 1.5 // Adjust opacity as needed
        
        makeImageViewCircular(imageView: ImageView)
    }
    
    func makeImageViewCircular(imageView: UIImageView) {
           // Ensure the UIImageView is square
           imageView.layer.cornerRadius = imageView.frame.size.width / 2
           imageView.clipsToBounds = true
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

   
}
