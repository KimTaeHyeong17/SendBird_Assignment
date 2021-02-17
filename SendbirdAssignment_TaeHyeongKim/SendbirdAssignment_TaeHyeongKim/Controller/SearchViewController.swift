//
//  ViewController.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UIView!
    
    //MARK: Global Variables
    private var resultArray: [BookModel] = []
    private var currentPage: Int = 1
    private var maxPage: Int = 1
    
    //MARK: View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        self.hideKeyboardWhenTappedAround()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        let curatingCellNib = UINib(nibName: "BookTableViewCell", bundle: nil)
        self.tableView.register(curatingCellNib, forCellReuseIdentifier: "BookTableViewCell")
        self.noResultLabel.isHidden = true
        
    }
    
    private func setSearchListView(data: SearchResultModel){
        
        self.maxPage = Int(data.total!)!/10+1 ///one page contains 10 result
        
        if let books = data.books {
            self.resultArray = books
        }
        
        DispatchQueue.main.async { [self] in
            searchBar.prompt = "total result \(data.total ?? "0") books was found!"
            if data.books?.count == 0 {
                noResultLabel.isHidden = false
            }else {
                noResultLabel.isHidden = true
            }
            tableView.reloadData()
        }
    }
    
    private func paginationCounter(data: SearchResultModel){
        if let books = data.books {
            resultArray.append(contentsOf: books)
            DispatchQueue.main.async { [self] in
                currentPage += 1
                tableView.reloadData()
            }
        }
    }
    
    //MARK: API Call
    private func searchBooks(keyword: String) {
        currentPage = 1
        
        SearchResultManager.shared.getSearchResult(
            keyword: keyword,
            page: currentPage
        ) { [weak self] (result) in
            // search result 가 cache 에 있을 때
            if let data = result {
                
                self?.setSearchListView(data: data)
                
            } else {// search result 가 cache에 없을 때
                NetworkService.shared.getSearchResult(
                    keyword: keyword,
                    page: self!.currentPage
                ) { [weak self] (result) in
                    switch result {
                    case .success(let data):
                        SearchResultManager.shared
                            .saveSearchResult(keyword: keyword, page: self!.currentPage, data: data)
                        
                        self?.setSearchListView(data: data)
                        
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func fetchMorePage(keyword: String) {
        DispatchQueue.global(qos: .background).async {
            SearchResultManager.shared.getSearchResult(
                keyword: keyword,
                page: self.currentPage
            ) { [weak self] (result) in
                // search result 가 cache 에 있을 때
                if let data = result {
                    
                    self?.paginationCounter(data: data)
                    
                } else {// search result 가 cache에 없을 때
                    NetworkService.shared.getSearchResult(keyword: keyword, page: self!.currentPage) { [weak self] (result) in
                        switch result {
                        case .success(let data):
                            SearchResultManager.shared.saveSearchResult(keyword: keyword, page: self!.currentPage, data: data)
                            self?.paginationCounter(data: data)
                        case .failure(let err):
                            print(err.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    private func fetchBookDetail(isbn13: String) {
        NetworkService.shared.getBookDetail(isbn13: isbn13){ [weak self] (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "DetailBookViewController") as? DetailBookViewController {
                        vc.title = "📓 Book Detail"
                        vc.bookData = data
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
extension SearchViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if currentPage < maxPage {
                if resultArray.count-1 == indexPath.row {
                    fetchMorePage(keyword: searchBar.text!)
                }
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
            let book = resultArray[indexPath.row]
            cell.selectionStyle = .none
            cell.titleLabel.text = book.title
            if book.subtitle?.count == 0 {
                cell.subTitleLabel.text = "no description available"
            } else {
                cell.subTitleLabel.text = book.subtitle
            }
            
            cell.isbn13Label.text = book.isbn13
            cell.priceLabel.text = book.price
            cell.imgView.image = nil
            cell.delegate = self
            cell.url = book.url
            UrlImageManager.shared.getUrlImage(book.image ?? "") { (image) in
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
        if let isbn13 = resultArray[indexPath.row].isbn13{
            fetchBookDetail(isbn13: isbn13)
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
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.5)
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
            searchBar.prompt = nil
            return
        }
        self.searchBooks(keyword: searchBar.text!)
    }
}
extension SearchViewController: OpenSafariViewControllerDelegate {
    func openSafariViewController(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
}
