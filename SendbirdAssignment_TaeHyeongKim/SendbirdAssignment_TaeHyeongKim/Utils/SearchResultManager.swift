//
//  SearchResultCache.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/17.
//

import Foundation

class StructHolder: NSObject {
    let data: SearchResultModel
    init(data: SearchResultModel) {
        self.data = data
    }
}

class SearchResultCacheManager {
    
    static let shared = NSCache<NSString, StructHolder>()
    
    private init() {}
}

class SearchResultManager {
    static let shared = SearchResultManager()
    
    public func getSearchResult(keyword: String, page: Int, completion: @escaping (SearchResultModel?) -> ()) {
        
        let cacheKey = NSString(string: "\(keyword)/\(page)")
        
        if let cacheData = SearchResultCacheManager.shared.object(forKey: cacheKey) {
            completion(cacheData.data)
        }else {
            completion(nil)
        }
    }
    
    public func saveSearchResult(keyword: String, page: Int, data: SearchResultModel?) {
        let cacheKey = NSString(string: "\(keyword)/\(page)")
        DispatchQueue.global(qos: .background).async {
            if let data = data {
                SearchResultCacheManager.shared.setObject(StructHolder(data: data), forKey: cacheKey)
            }
        }
    }
}
