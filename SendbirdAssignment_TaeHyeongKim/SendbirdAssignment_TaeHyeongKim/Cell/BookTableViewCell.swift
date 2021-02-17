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
    public var url: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        //request cancel
        imgView.image = nil
    }
    
    @IBAction func actionLink(_ sender: Any) {
        if let url = url {
            delegate?.openSafariViewController(url: url)
        }
    }
    

}
