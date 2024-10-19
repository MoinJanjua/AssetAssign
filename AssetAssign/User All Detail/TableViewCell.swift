//
//  TableViewCell.swift
//  AssetAssign
//
//  Created by Moin Janjua on 20/08/2024.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cView: UIView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var itemLabe: UILabel!
    
    @IBOutlet weak var remainDayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        remainDayLabel.layer.cornerRadius = 15 // Adjust as needed
        remainDayLabel.clipsToBounds = true
        cView.layer.cornerRadius = 12
        
        // Set up shadow properties
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cView.layer.shadowOpacity = 0.3
        cView.layer.shadowRadius = 4.0
        cView.layer.masksToBounds = false
        
        // Set background opacity
        cView.alpha = 1.5 // Adjust opacity as needed
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }

}
