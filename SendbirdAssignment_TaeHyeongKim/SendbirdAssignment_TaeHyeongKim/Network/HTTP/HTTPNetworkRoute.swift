//
//  HTTPNetworkRoute.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/21.
//

import Foundation

public enum HTTPNetworkRoute {
    case searchBook(query: String, page: Int)
    case bookDetail(query: String)
    var url: String{
        switch self {
        case .searchBook(query: let keyword, page: let num):
            return "search/\(keyword)/\(num)"
        case .bookDetail(query: let isbn13):
            return "books/\(isbn13)"
        }
    }
}
