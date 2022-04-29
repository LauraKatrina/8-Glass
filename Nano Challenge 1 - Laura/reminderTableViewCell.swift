//
//  reminderTableViewCell.swift
//  Nano Challenge 1 - Laura
//
//  Created by Laura Katrina on 28/04/22.
//

import UIKit

class reminderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var myLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let cellBg = UIImage(named: "Rectangle 7")
        self.backgroundView = UIImageView(image: cellBg)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
