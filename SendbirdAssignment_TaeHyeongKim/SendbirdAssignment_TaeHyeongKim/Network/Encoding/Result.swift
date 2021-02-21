//
//  Result.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/21.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
