//
//  BookModel.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/20.
//

import Foundation

struct BookModel: Decodable, Hashable {
    var title: String?
    var subtitle: String?
    var isbn13: String?
    var image: String?
    var url: String?
    var price: String?
}
