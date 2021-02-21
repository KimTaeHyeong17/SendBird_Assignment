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
    @Published var resultData: BookSearchModel
    
    public var currentPage: Int = 1
    public var maxPage: Int = 1
    
    init(searchResultModel:  [BookModel], resultData: BookSearchModel) {
        self.searchResultArray = searchResultModel
        self.resultData = resultData
    }
    
    private func setSearchListView(data: BookSearchModel){
        resultData = data
        if let total = data.total {
            self.maxPage = Int(total)!/10+1
        }///one page contains 10 result
        
        if let books = data.books {
            self.searchResultArray = books
        }
        currentPage += 1
    }
    
    private func paginationCounter(data: BookSearchModel){
        if let books = data.books, let page = data.page{
            print("page \(page)")
            searchResultArray.append(contentsOf: books)
            currentPage += 1
        }
    }
    
    public func removeResult(){
        searchResultArray.removeAll()
        currentPage = 1
    }
    
    //MARK: API Call    
    public func fetchSearchResult(keyword: String) {
        var gotFromCache: Bool = false
        SearchResultManager.shared.getSearchResultFromCache(
            keyword: keyword,
            page: self.currentPage
        ) { [weak self] (result) in
            /// search result 가 cache(disk + memory) 에 있을 때
            if let data = result {
                if self?.currentPage == 1 {
                    self?.setSearchListView(data: data)
                }else {
                    self?.paginationCounter(data: data)
                }
                gotFromCache.toggle()
            } else {/// search result 가 cache에 없을 때
                NetworkService.shared.getSearchResult(keyword: keyword, page: self!.currentPage) { [weak self] (result) in
                    if gotFromCache == true {//TODO: although data was found at cache, this code execute.
                        return
                    }
                    switch result {
                    case .success(let data):
                        print("get from url        \(self?.currentPage ?? -1)")
                        SearchResultManager.shared
                            .saveAtMemory(keyword: keyword, page: self!.currentPage, data: data)
                        SearchResultManager.shared
                            .saveAtDisk(keyword: keyword, page: self!.currentPage, data: data)
                        
                        if self?.currentPage == 1 {
                            self?.setSearchListView(data: data)
                        }else {
                            self?.paginationCounter(data: data)
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
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
