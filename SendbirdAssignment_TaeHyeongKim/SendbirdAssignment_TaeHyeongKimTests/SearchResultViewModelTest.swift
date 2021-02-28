//
//  SearchResultViewModelTest.swift
//  SendbirdAssignment_TaeHyeongKimTests
//
//  Created by TaeHyeong Kim on 2021/02/28.
//

import XCTest

@testable import SendbirdAssignment_TaeHyeongKim

class SearchResultViewModelTest: XCTestCase {
    private var viewModel: SearchResultViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SearchResultViewModel(searchResultModel: [], resultData: BookSearchModel())
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDuplication(){
        let keyword = "java"
        viewModel.fetchSearchResult(keyword: keyword)
        
        while viewModel.currentPage <= viewModel.maxPage {
            viewModel.fetchSearchResult(keyword: keyword)
            sleep(UInt32(5))
        }
        
        
        
        XCTAssertEqual(Set(viewModel.searchResultArray).count, viewModel.searchResultArray.count)
    }
}
