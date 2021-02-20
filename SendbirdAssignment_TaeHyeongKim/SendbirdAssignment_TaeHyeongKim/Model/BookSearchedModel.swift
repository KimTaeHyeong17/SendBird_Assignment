//
//  BookSearchedModel.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import Foundation
import CoreData

struct BookSearchModel: Decodable {
    var total: String?
    var page: String?
    var books: [BookModel]?

}
