//
//  HTTPNetworkRequest.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/21.
//

import Foundation

public typealias HTTPParameters = [String:Any]?

public typealias HTTPHeaders = [String:Any]?

struct HTTPNetworkRequest {
    static func configureHTTPRequest(
        from route: HTTPNetworkRoute,
        with parameters: HTTPParameters,
        includes headers: HTTPHeaders,
        contains body: Data?,
        and method: HTTPMethod) throws -> URLRequest {
        guard let urlString = "https://api.itbook.store/1.0/\(route.url)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw HTTPNetworkError.missingURL
        }
        guard let url = URL(string: urlString) else {
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
