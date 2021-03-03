//
//  BookTableViewCell.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import UIKit

class BookTableViewCell: UITableViewCell {
  
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var isbn13Label: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var btnLink: UIButton!
    
    public var delegate: OpenSafariViewControllerDelegate?
    public var url: String? /// for opening book info link
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        titleLabel.text = nil
        subTitleLabel.text = nil
        isbn13Label.text = nil
        priceLabel.text = nil
    }
    
    @IBAction func actionLink(_ sender: Any) {
        if let url = url {
            delegate?.openSafariViewController(url: url)
        }
    }
}
