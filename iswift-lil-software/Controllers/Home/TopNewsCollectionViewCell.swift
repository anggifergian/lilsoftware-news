//
//  TopNewsCollectionViewCell.swift
//  iswift-lil-software
//
//  Created by Anggi Fergian on 05/05/23.
//

import UIKit

class TopNewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topThumbImage: UIImageView!
    @IBOutlet weak var topHeadingLbl: UILabel!
    @IBOutlet weak var topDateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        topThumbImage.layer.cornerRadius = 8
        topThumbImage.layer.masksToBounds = true
    }
}
