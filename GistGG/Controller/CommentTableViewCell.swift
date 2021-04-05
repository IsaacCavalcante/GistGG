//
//  CommentTableViewCell.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 03/04/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        ownerImage.layer.cornerRadius = ownerImage.frame.size.width/2
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
