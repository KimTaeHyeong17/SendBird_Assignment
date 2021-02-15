//
//  BookSearchedModel.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import Foundation

struct SearchResultModel: Decodable {
    var total: String?
    var page: String?
    var books: [BookModel]?
}
struct BookModel: Decodable {
    var title: String?
    var subtitle: String?
    var isbn13: String?
    var image: String?
    var url: String?
    var price: String?
}
