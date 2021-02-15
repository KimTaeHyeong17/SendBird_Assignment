//
//  DetailBookViewController.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import UIKit

class DetailBookViewController: UIViewController {
    
    var isbn13: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBookDetail(isbn13: isbn13)
    }
    
    
    private func getBookDetail(isbn13: String) {
        NetworkService.shared.getBookDetail(isbn13: isbn13){ (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
}
