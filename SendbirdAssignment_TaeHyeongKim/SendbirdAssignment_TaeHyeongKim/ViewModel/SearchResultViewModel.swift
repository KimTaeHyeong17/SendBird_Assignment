//
//  SearchResultViewModel.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/18.
//

import Foundation
import Combine

class SearchResultViewModel: ObservableObject {
    
    @Published var searchResultArray: [BookModel]
    @Published var resultData: SearchResultModel
    
    public var currentPage: Int = 1
    public var maxPage: Int = 1
    
    init(searchResultModel:  [BookModel], resultData: SearchResultModel) {
        self.searchResultArray = searchResultModel
        self.resultData = resultData
    }
    
    private func setSearchListView(data: SearchResultModel){
        resultData = data
        if let total = data.total {
            self.maxPage = Int(total)!/10+1
        }///one page contains 10 result
        
        if let books = data.books {
            self.searchResultArray = books
        }
    }
    
    private func paginationCounter(data: SearchResultModel){
        if let books = data.books {
            searchResultArray.append(contentsOf: books)
                currentPage += 1
        }
    }
    
    public func removeResult(){
        searchResultArray.removeAll()
    }
    
    //MARK: API Call
    public func searchBooks(keyword: String) {
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
    
    public func fetchMorePage(keyword: String) {
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
    
    public func fetchBookDetail(isbn13: String, completion: @escaping (BookDetailModel) -> ()) {
        NetworkService.shared.getBookDetail(isbn13: isbn13){ (result) in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }

}
