//
//  Network.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/15.
//

import Foundation


//https://api.itbook.store/1.0/search/{query}
//https://api.itbook.store/1.0/search/{query}/{page}
//https://api.itbook.store/1.0/books/{isbn13}


enum Result<T> {
    case success(T)
    case failure(Error)
}

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
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
public enum HTTPNetworkError: String, Error {
    case parametersNil = "Error Found : Parameters are nil."
    case headersNil = "Error Found : Headers are Nil"
    case encodingFailed = "Error Found : Parameter Encoding failed."
    case decodingFailed = "Error Found : Unable to Decode the data."
    case missingURL = "Error Found : The URL is nil."
    case couldNotParse = "Error Found : Unable to parse the JSON response."
    case noData = "Error Found : The data from API is Nil."
    case FragmentResponse = "Error Found : The API's response's body has fragments."
    case UnwrappingError = "Error Found : Unable to unwrape the data."
    case dataTaskFailed = "Error Found : The Data Task object failed."
    case success = "Successful Network Request"
    case authenticationError = "Error Found : You must be Authenticated"
    case badRequest = "Error Found : Bad Request"
    case pageNotFound = "Error Found : Page/Route rquested not found."
    case failed = "Error Found : Network Request failed"
    case serverSideError = "Error Found : Server error"
}

public typealias HTTPParameters = [String:Any]?

public typealias HTTPHeaders = [String:Any]?

struct HTTPNetworkRequest {
    static func configureHTTPRequest(
        from route: HTTPNetworkRoute,
        with parameters: HTTPParameters,
        includes headers: HTTPHeaders,
        contains body: Data?,
        and method: HTTPMethod) throws -> URLRequest {
        guard let url = URL(string: "https://api.itbook.store/1.0/\(route.url)") else {
            throw HTTPNetworkError.missingURL
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        request.httpMethod = method.rawValue
        request.httpBody = body
        try configureParametersAndHeaders(parameters: parameters, headers: headers, request: &request)
        
        return request
        
    }
    static func configureParametersAndHeaders(
        parameters: HTTPParameters?,
        headers: HTTPHeaders?,
        request: inout URLRequest) throws {
        do {
            if let headers = headers, let parameters = parameters {
                try URLEncoder.encodeParameters(for: &request, with: parameters)
                try URLEncoder.setHeaders(for: &request, with: headers)
            }
        } catch {
            throw HTTPNetworkError.encodingFailed
        }
    }
}

struct HTTPNetworkResponse {
    static func handleNetworkResponse(for response: HTTPURLResponse?) -> Result<String>{
        
        guard let res = response else { return Result.failure(HTTPNetworkError.UnwrappingError.rawValue as! Error)
        }
        
        switch res.statusCode {
        case 200...299: return Result.success(HTTPNetworkError.success.rawValue)
        case 401: return Result.failure(HTTPNetworkError.authenticationError)
        case 400...499: return Result.failure(HTTPNetworkError.badRequest)
        case 500...599: return Result.failure(HTTPNetworkError.serverSideError)
        default: return Result.failure(HTTPNetworkError.failed)
        }
    }
}

public struct URLEncoder {
    static func encodeParameters(
        for urlRequest: inout URLRequest,
        with parameters: HTTPParameters) throws {
        
        if parameters == nil { return }
        
        guard let url = urlRequest.url, let unwrappedParameters = parameters else {
            throw HTTPNetworkError.missingURL
        }
    
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !unwrappedParameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in unwrappedParameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
    }
    
    static func setHeaders(for urlRequest: inout URLRequest, with headers: HTTPHeaders) throws {
        if headers == nil { return }
        guard let unwrappedHeaders = headers else { throw HTTPNetworkError.headersNil }
        for (key, value) in unwrappedHeaders{
            urlRequest.setValue(value as? String, forHTTPHeaderField: key)
        }
    }
}

struct NetworkService {
    
    static let shared = NetworkService()
    
    let session = URLSession(configuration: .default)
    
    func getSearchResult(keyword: String ,page: Int,  _ completion: @escaping (Result<SearchResultModel>) -> ()) {
        do {
            let request = try HTTPNetworkRequest.configureHTTPRequest(
                from: .searchBook(query: keyword,page: page), with: nil, includes: nil, contains: nil, and: .get)
            
            session.dataTask(with: request){ (data, res, err) in
                if let response = res as? HTTPURLResponse, let unwrappedData = data {
                    let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                    switch result {
                    case .success:
                        let result = try? JSONDecoder().decode(SearchResultModel.self, from: unwrappedData)
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
