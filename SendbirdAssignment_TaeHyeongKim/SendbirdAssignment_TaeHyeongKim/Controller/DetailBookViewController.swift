//
//  DetailBookViewController.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import UIKit
import SafariServices

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
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var tvMemo: UITextView!
    
    
    @IBOutlet weak var ratingStar0: UIImageView!
    @IBOutlet weak var ratingStar1: UIImageView!
    @IBOutlet weak var ratingStar2: UIImageView!
    @IBOutlet weak var ratingStar3: UIImageView!
    @IBOutlet weak var ratingStar4: UIImageView!
    
    public var bookData: BookDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBookDetail(data: bookData!)
        self.hideKeyboardWhenTappedAround()
        addKeyboardNotification()
        getMemo()
        tvMemo.layer.cornerRadius = 5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveMemo()
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
        setStar(num: Int(data.rating ?? "0")!)
        lbDescription.text = data.desc
        lbPrice.text = data.price
        if let img = data.image {
            UrlImageManager.shared.getImage(url: img) { (image) in
                self.imgBook.image = image
            }
            
        }
    }
    
    private func saveMemo(){
        if let data = bookData, let isbn13 = data.isbn13 {
            if tvMemo.text.count != 0 {
                UserDefaults.standard.set(tvMemo.text, forKey: isbn13)
            }
        }
    }
    
    private func getMemo() {
        if let data = bookData, let isbn13 = data.isbn13 {
            if let memo = UserDefaults.standard.string(forKey: isbn13) {
                tvMemo.text = memo
            }
        }
    }
    
    private func setStar(num: Int){
        let stars : [UIImageView] = [ratingStar0,ratingStar1,ratingStar2,ratingStar3,ratingStar4]
        for index in 0..<num {
            stars[index].image = UIImage(systemName: "star.fill")
        }
    }
    
    @IBAction func actionMoveToLink(_ sender: Any) {
        if let data = bookData, let url = data.url{
            let safariVC = SFSafariViewController(url: URL(string: url)!)
            self.present(safariVC, animated: true, completion: nil)
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


