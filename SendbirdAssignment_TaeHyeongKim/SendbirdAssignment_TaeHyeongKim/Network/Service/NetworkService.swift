//
//  NetworkService.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/21.
//

import Foundation

struct NetworkService {
    
    static let shared = NetworkService()
    
    let session = URLSession(configuration: .default)
    
    func getSearchResult(keyword: String ,page: Int,  _ completion: @escaping (Result<BookSearchModel>) -> ()) {
        do {
            let request = try HTTPNetworkRequest.configureHTTPRequest(
                from: .searchBook(query: keyword,page: page), with: nil, includes: nil, contains: nil, and: .get)
            session.dataTask(with: request){ (data, res, err) in
                if let response = res as? HTTPURLResponse, let unwrappedData = data {
                    let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(BookSearchModel.self, from: unwrappedData)
                        completion(Result.success(result!))
                    case .failure(let err):
                        
                        response.statusCode
                        completion(Result.failure(HTTPNetworkError.badRequest))
                    }
                }
            }.resume()
    
        }catch {
            completion(Result.failure(HTTPNetworkError.badRequest))
        }
    }
    
    func getBookDetail(isbn13: String ,_ completion: @escaping (Result<BookDetailModel>) -> ()) {
        do {
            let request = try HTTPNetworkRequest.configureHTTPRequest(
                from: .bookDetail(query: isbn13), with: nil, includes: nil, contains: nil, and: .get)
            
            session.dataTask(with: request){ (data, res, err) in
                if let response = res as? HTTPURLResponse, let unwrappedData = data {
                    let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(BookDetailModel.self, from: unwrappedData)
                        completion(Result.success(result!))
                    case .failure:
                        completion(Result.failure(HTTPNetworkError.badRequest))
                        
                    }
                }
            }.resume()
    
        }catch {
            completion(Result.failure(HTTPNetworkError.badRequest))
        }
    }
    
}
