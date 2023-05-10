//
//  NewsViewCell.swift
//  iswift-lil-software
//
//  Created by Anggi Fergian on 05/05/23.
//

import UIKit

protocol NewsViewCellDelegate: AnyObject {
    func newsViewCellBookmarkButtonTapped(_ cell: NewsViewCell)
}

class NewsViewCell: UITableViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    weak var delegate: NewsViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setup()
    }
    
    func setup() {
        thumbImage.layer.cornerRadius = 8
        thumbImage.layer.masksToBounds = true
    }

    @IBAction func bookmarkBtnTapped(_ sender: Any) {
        delegate?.newsViewCellBookmarkButtonTapped(self)
    }
    
}
