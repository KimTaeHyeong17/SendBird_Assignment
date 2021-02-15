//
//  BookDetailModel.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import Foundation

struct BookDetailModel: Decodable {
    var error: String?
    var title: String?
    var subtitle: String?
    var authors: String?
    var publisher: String?
    var language: String?
    var isbn10: String?
    var isbn13: String?
    var pages: String?
    var year: String?
    var rating: String?
    var desc: String?
    var price: String?
    var image: String?
    var url: String?
}
