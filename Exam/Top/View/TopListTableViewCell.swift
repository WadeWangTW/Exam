//
//  TopListTableViewCell.swift
//  Exam
//
//  Created by Wade Wang on 2020/11/5.
//

import UIKit
import SDWebImage

protocol TopListCellDelegate {
    func cell(_ cell: TopListTableViewCell, didClickedFavorite topItem: TopItem)
}

class TopListTableViewCell: UITableViewCell {

    @IBOutlet weak var topItemImageView: UIImageView!
    @IBOutlet weak var topItemTitleLabel: UILabel!
    @IBOutlet weak var topItemTypeLabel: UILabel!
    @IBOutlet weak var topItemRankLabel: UILabel!
    @IBOutlet weak var topItemDurationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var delegate: TopListCellDelegate?
    var topItem: TopItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(_ delegate: TopListCellDelegate, top: TopItem) {
        self.topItem = top
        self.delegate = delegate
        
        if let image = top.image_url {
            topItemImageView.sd_setImage(with: URL(string: image), completed: nil)
        }
        else {
            topItemImageView.image = nil
        }
        
        topItemTitleLabel.text = top.title
        topItemTypeLabel.text = top.type
        
        if let rank = top.rank {
            topItemRankLabel.text = "Rank: \(rank)"
        }
        else {
            topItemRankLabel.text = "Rank: -"
        }
        
        if let start = top.start_date, let end = top.end_date {
            topItemDurationLabel.text = "Duration: \(start) - \(end)"
        }
        else {
            topItemDurationLabel.text = "Duration: -"
        }
        
        
        if let favorite = topItem.favorite {
            favoriteButton.isSelected = favorite
        }
        else {
            favoriteButton.isSelected = false
        }
    }
    
    @IBAction func favoriteClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.cell(self, didClickedFavorite: topItem)
    }
}
