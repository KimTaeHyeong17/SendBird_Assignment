//
//  DetailBookViewController.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import UIKit

class DetailBookViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var lbPublisher: UILabel!
    @IBOutlet weak var lbLanguage: UILabel!
    @IBOutlet weak var lbIsbn10: UILabel!
    @IBOutlet weak var lbIsbn13: UILabel!
    @IBOutlet weak var lbPages: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var tvMemo: UITextView!
    
    var bookData: BookDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBookDetail(data: bookData!)
        self.hideKeyboardWhenTappedAround()
        addKeyboardNotification()
    }
    
    private func setBookDetail(data: BookDetailModel){
        lbTitle.text = data.title
        lbSubTitle.text = data.subtitle
        lbAuthor.text = data.authors
        lbPublisher.text = data.publisher
        lbLanguage.text = data.language
        lbIsbn10.text = data.isbn10
        lbIsbn13.text = data.isbn13
        lbPages.text = data.pages
        lbYear.text = data.year
        lbRating.text = data.rating
        lbDescription.text = data.desc
        lbPrice.text = data.price
        if let img = data.image {
            UrlImageManager.shared.getUrlImage(img) { (image) in
                self.imgBook.image = image
            }
        }
    }
    
  
}
extension DetailBookViewController {
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow),
          name: UIResponder.keyboardWillShowNotification,
          object: nil
        )
        
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide),
          name: UIResponder.keyboardWillHideNotification,
          object: nil
        )
      }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        let keybaordRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keybaordRectangle.height
        containerView.frame.origin.y -= keyboardHeight
      }
    }
      
    @objc private func keyboardWillHide(_ notification: Notification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        let keybaordRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keybaordRectangle.height
        containerView.frame.origin.y += keyboardHeight
      }
    }
}
 
