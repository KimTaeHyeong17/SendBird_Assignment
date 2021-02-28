//
//  ViewController.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import UIKit
import SafariServices
import Combine

class SearchViewController: UIViewController {
    
    private var viewModel: SearchResultViewModel!
    private var cancelables: Set<AnyCancellable> = []
    private var lastSearchedKeyword: String = ""
    
    //MARK: IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UIView!
    
    //MARK: View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModel()
        bindViewModel()
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
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "clear Cache", style: .plain, target: self, action: #selector(clearCache))

    }
    
    private func setupViewModel(){
        viewModel = SearchResultViewModel(searchResultModel: [], resultData: BookSearchModel())
    }
    
    private func bindViewModel(){
        let searchResultStream = viewModel.$searchResultArray
            .sink{ [weak self] _ in
                DispatchQueue.main.async { [self] in
                    self?.tableView.reloadData()
                }
            }
        
        let resultDataStream = viewModel.$resultData
            .sink{ [weak self] _ in
                DispatchQueue.main.async { [self] in
                    if (self?.searchBar.text!.count)! > 0 {
                        self?.searchBar.prompt = "total result \(self?.viewModel.resultData.total ?? "0") books was found!"
                        
                    }else {
                        self?.noResultLabel.isHidden = true
                    }
                    
                    if self?.viewModel.resultData.books?.count == 0 {
                        self?.noResultLabel.isHidden = false
                    }else {
                        self?.noResultLabel.isHidden = true
                    }
                }
            }
        cancelables.insert(searchResultStream)
        cancelables.insert(resultDataStream)
    }
    
//    @objc func clearCache() {
//        CoreDataManager.shared.deleteAllData()
//    }
    
}
extension SearchViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if viewModel.currentPage <= viewModel.maxPage {
                if (viewModel.currentPage-1)*10-1 <= indexPath.row { ///한페이지당 10개, 호출시점의 페이지는 현재페이지+=1 된 시점, index 0 부터 시작하니 -1, 요청한 row 인덱스가 계산값보다 같거나 클때 fetchMore
                    viewModel.fetchSearchResult(keyword: searchBar.text!)
                }
            }
        }
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell") as? BookTableViewCell {
            
            let book = viewModel.searchResultArray[indexPath.row]
            cell.selectionStyle = .none
            cell.titleLabel.text = book.title
            if book.subtitle?.count == 0 {
                cell.subTitleLabel.text = "no description available"
            } else {
                cell.subTitleLabel.text = book.subtitle
            }
            
            cell.isbn13Label.text = book.isbn13
            cell.priceLabel.text = book.price
            cell.delegate = self
            cell.url = book.url
            cell.imgView.image = UIImage(named: "bookPlaceholder")
            if let url = book.image {
                UrlImageManager.shared.getImage(url: url) { (image) in
                    cell.imgView.image = image
                }
            }
          
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let isbn13 = viewModel.searchResultArray[indexPath.row].isbn13 {
            tableView.cellForRow(at: indexPath)?.isUserInteractionEnabled = false
            viewModel.fetchBookDetail(isbn13: isbn13) { [weak self] (data) in
                DispatchQueue.main.async {
                    if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "DetailBookViewController") as? DetailBookViewController {
                        vc.title = "📓 Book Detail"
                        vc.bookData = data
                        self?.navigationController?.pushViewController(vc, animated: true)
                        tableView.cellForRow(at: indexPath)?.isUserInteractionEnabled = true
                    }
                }
            }
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
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            viewModel.removeResult()
            tableView.reloadData()
            searchBar.prompt = nil
            noResultLabel.isHidden = true
            return
        }
        if lastSearchedKeyword != query {
            viewModel.removeResult()
        }
        viewModel.fetchSearchResult(keyword: query)
        lastSearchedKeyword = query
//        print("searched keyword \(query)")
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
