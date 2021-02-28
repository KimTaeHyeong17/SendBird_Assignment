//
//  SearchResultCache.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/17.
//

import Foundation
import CoreData
import UIKit

class StructHolder: NSObject {
    let data: BookSearchModel
    init(data: BookSearchModel) {
        self.data = data
    }
}

class SearchResultCacheManager {
    
    static let shared = NSCache<NSString, StructHolder>()
    
    private init() {}
}

class SearchResultManager {
    static let shared = SearchResultManager()
    
    @available(*, deprecated, message: "use getSearchResultFromCache method instead")
    public func getSearchResult(keyword: String, page: Int, completion: @escaping (BookSearchModel?) -> ()) {
        let cacheKey = NSString(string: "\(keyword)/\(page)")
        
        if let cacheData = SearchResultCacheManager.shared.object(forKey: cacheKey) {
            completion(cacheData.data)
        }else {
            completion(nil)
        }
    }
    
    @available(*, deprecated, message: "use saveAtMemory or saveAtDisk method instead")
    public func saveSearchResult(keyword: String, page: Int, data: BookSearchModel?) {
        let cacheKey = NSString(string: "\(keyword)/\(page)")
        DispatchQueue.global(qos: .background).async {
            if let data = data {
                SearchResultCacheManager.shared.setObject(StructHolder(data: data), forKey: cacheKey)
            }
        }
    }
    
    
    public func getSearchResultFromCache(keyword: String, page: Int, completion: @escaping (BookSearchModel?) -> ()) {
        //get from memory cache
        getSearchResultFromMemory(keyword: keyword, page: page) { (data) in
            if let data = data {
                print("get from memory     \(page)")
                completion(data)
            } else {
                self.getSearchResultFromDisk(keyword: keyword, page: page) { (data) in
                    if let data = data {
                        print("get from disk       \(page)")
                        completion(data)
                        self.saveAtMemory(keyword: keyword, page: page, data: data)
                    }else {
                        print("call api \(page)")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    private func getSearchResultFromMemory(keyword: String, page: Int, completion: @escaping (BookSearchModel?) -> ()) {
        
        let cacheKey = NSString(string: "\(keyword)/\(page)")
        
        if let cacheData = SearchResultCacheManager.shared.object(forKey: cacheKey) {
            print("   found at memory")
            completion(cacheData.data)
        }else {
            print("  not found at memory")
            completion(nil)
        }
    }
    
    private func getSearchResultFromDisk(keyword: String, page: Int, completion: @escaping (BookSearchModel?) -> ()) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            let content = try context.fetch(SearchResultEntity.fetchRequest()) as! [SearchResultEntity]
            ///fetch all data, need filtering
            for item in content {
                if item.keyword == keyword && item.page == "\(page)" {
                    //                    print("data found in disk \(keyword) \(page)")
                    ///data found -> convert to BookSearchModel
                    var books = [BookModel]()
                    for book in item.books! {
                        if let book = book as? BookModelEntity,
                           let title = book.title,
                           let subtitle = book.subtitle,
                           let isbn13 = book.isbn13,
                           let image = book.image,
                           let url = book.url,
                           let price = book.price {
                            books.append(
                                BookModel(
                                    title: title,
                                    subtitle: subtitle,
                                    isbn13: isbn13,
                                    image: image,
                                    url: url,
                                    price: price
                                )
                            )
                        }
                    }
                    completion(BookSearchModel(total: item.total, page: item.page ,books: books))
                    break
                }
                else {
                    completion(nil)
                    break
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    public func saveAtMemory(keyword: String, page: Int, data: BookSearchModel?) {
        let cacheKey = NSString(string: "\(keyword)/\(page)")
        DispatchQueue.global(qos: .background).async {
            if let data = data {
                SearchResultCacheManager.shared.setObject(StructHolder(data: data), forKey: cacheKey)
                print("save to memory      \(page)")

            }
        }
        
    }
    
    public func saveAtDisk(keyword: String, page: Int, data: BookSearchModel) {
        DispatchQueue.global(qos: .background).async {
            
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "SearchResultEntity", in: context)
            
            if entity != nil {
                context.perform {
                    let searchResult = SearchResultEntity(context: context)
                    searchResult.total = data.total
                    searchResult.page = data.page
                    searchResult.keyword = keyword
                    
                    var books = [BookModelEntity(context: context)]
                    for item in data.books! {
                        let book = BookModelEntity(context: context)
                        book.image = item.image
                        book.isbn13 = item.isbn13
                        book.price = item.price
                        book.subtitle = item.subtitle
                        book.title = item.title
                        book.url = item.url
                        books.append(book)
                    }
                    searchResult.books = NSOrderedSet(array: books)
                    
                    do {
                        try context.save()
                        print("save to disk        \(page)")
                        
                    } catch {
                        print("coredata savedisk error \n \(error.localizedDescription)")
                    }
                    
                }
            }
        }
        
    }
    
    
}
