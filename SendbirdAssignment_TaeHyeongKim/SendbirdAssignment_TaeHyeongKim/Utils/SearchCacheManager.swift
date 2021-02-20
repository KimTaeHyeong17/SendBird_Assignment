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
    
    
    
    // TODO: add disk cache layer
    public func getSearchResultFromCache(keyword: String, page: Int, completion: @escaping (BookSearchModel?) -> ()) {
        //get from memory cache
        getSearchResultFromMemory(keyword: keyword, page: page) { (data) in
            if let data = data {
                print("get from memory     \(page)")
                completion(data)
            }else {
                //                completion(nil)
                //                get from disk cache
                //                save to memory cache
                self.getSearchResultFromDisk(keyword: keyword, page: page) { (data) in
                    if let data = data {
                        print("get from disk       \(page)")
                        completion(data)
                        self.saveAtMemory(keyword: keyword, page: page, data: data)
                    }else {
                        //TODO: get from url and save to disk and memory is done in viewModel
                        completion(nil)
                    }
                }
            }
        }
    }
    
    private func getSearchResultFromMemory(keyword: String, page: Int, completion: @escaping (BookSearchModel?) -> ()) {
        let cacheKey = NSString(string: "\(keyword)/\(page)")
        
        if let cacheData = SearchResultCacheManager.shared.object(forKey: cacheKey) {
            completion(cacheData.data)
        }else {
            completion(nil)
        }
    }
    
    private func getSearchResultFromDisk(keyword: String, page: Int, completion: @escaping (BookSearchModel?) -> ()) {
        DispatchQueue.main.async {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                let content = try context.fetch(SearchResultEntity.fetchRequest()) as! [SearchResultEntity]
                
                ///fetch all data, need filtering
                for item in content {
                    if item.keyword == keyword && item.page == "\(page)" {
                        ///data found -> convert to BookSearchModel
                        //                        item.books as BookModelEntity
                        var books = [BookModel]()
                        for book in item.books! {
                            if let book = book as? BookModelEntity {
                                books.append(
                                    BookModel(
                                        title: book.title,
                                        subtitle: book.subtitle,
                                        isbn13: book.isbn13,
                                        image: book.image,
                                        url: book.url,
                                        price: book.price
                                    )
                                )
                            }
                        }
                        completion(BookSearchModel(total: item.total, page: item.page ,books: books))
                    }
                }
                /// not found return nil
                completion(nil)
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    public func saveAtMemory(keyword: String, page: Int, data: BookSearchModel?) {
        let cacheKey = NSString(string: "\(keyword)/\(page)")
        DispatchQueue.global(qos: .background).async {
            if let data = data {
                SearchResultCacheManager.shared.setObject(StructHolder(data: data), forKey: cacheKey)
            }
        }
        print("save to memory      \(page)")
        
    }
    
    public func saveAtDisk(keyword: String, page: Int, data: BookSearchModel) {
        //TODO: saveing should be in background thread move persistentContainer outside from appDelegate
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "SearchResultEntity", in: context)
            
            if entity != nil {
                //                let searchResult = NSManagedObject(entity: entity, insertInto: context) as! SearchResultEntity
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
