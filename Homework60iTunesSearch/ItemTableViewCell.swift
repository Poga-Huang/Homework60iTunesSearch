//
//  ItemTableViewCell.swift
//  Homework60iTunesSearch
//
//  Created by 黃柏嘉 on 2022/1/25.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
