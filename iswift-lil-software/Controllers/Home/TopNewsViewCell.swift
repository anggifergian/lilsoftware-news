//
//  TopNewsViewCell.swift
//  iswift-lil-software
//
//  Created by Anggi Fergian on 05/05/23.
//

import UIKit

protocol TopNewsViewCellDelegate: AnyObject {
    func topNewsViewCellPageControlValueChanged(_ cell: TopNewsViewCell)
}

class TopNewsViewCell: UITableViewCell {

    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topCollectionView: UICollectionView!
    
    weak var delegate: TopNewsViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pageControlValueChanged(_ sender: Any) {
        delegate?.topNewsViewCellPageControlValueChanged(self)
    }
}
