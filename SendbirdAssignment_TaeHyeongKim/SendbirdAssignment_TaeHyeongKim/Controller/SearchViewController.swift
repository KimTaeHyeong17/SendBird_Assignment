//
//  ViewController.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noResultLabel: UIView!
    
    private var resultArray: [BookModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        self.hideKeyboardWhenTappedAround()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        let curatingCellNib = UINib(nibName: "BookTableViewCell", bundle: nil)
        self.tableView.register(curatingCellNib, forCellReuseIdentifier: "BookTableViewCell")
        self.noResultLabel.isHidden = true

    }
    
    private func searchBooks(keyword: String) {
        NetworkService.shared.getSearchResult(keyword: keyword) { (result) in
            switch result {
            case .success(let data):
                if let books = data.books {
                    self.resultArray = books
                    DispatchQueue.main.async {
                        if books.count == 0 {
                            self.noResultLabel.isHidden = false
                        }else {
                            self.noResultLabel.isHidden = true
                        }
                        self.tableView.reloadData()
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell") as? BookTableViewCell {
            print(resultArray)
            let book = resultArray[indexPath.row]
            cell.titleLabel.text = book.title
            cell.subTitleLabel.text = book.subtitle
            cell.isbn13Label.text = book.isbn13
            cell.priceLabel.text = book.price
            urlImageManager.shared.getUrlImage(book.image ?? "") { (image) in
                cell.imgView.image = image
            }
          
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailBookViewController") as? DetailBookViewController,let isbn13 = resultArray[indexPath.row].isbn13 {
            vc.isbn13 = isbn13
            vc.title = "📓 Book Detail"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(self.reload(_:)),
            object: searchBar
        )
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            resultArray.removeAll()
            tableView.reloadData()
            return
        }
        self.searchBooks(keyword: searchBar.text!)
    }
}
