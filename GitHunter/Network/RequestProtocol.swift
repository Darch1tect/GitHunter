//
//  RequestProtocol.swift
//  ClientRedd
//
//  Created by Vitalii Roditieliev on 6/28/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol RequestProtocol {
    
    var invalidationToken: InvalidationToken? { get set }
    var context: Context? { get set }
    var endpoint: String { get set }
    var method: RequestMethod? { get set }
    var fields: ParametersDict? { get set }
    var urlParams: ParametersDict? { get set }
    var body: RequestBody? { get set }
    var headers: HeadersDict? { get set }
    var cashePolicy: URLRequest.CachePolicy? { get set }
    var timeout: TimeInterval? { get set }
    
    // functions
    func headers(in service: ServiceProtocol) -> HeadersDict
    func url(in service: ServiceProtocol) throws -> URL
    func urlRequest(in service: ServiceProtocol) throws -> URLRequest
}

// MARK: - Default Request implementation

public extension RequestProtocol {
    
    func headers(in service: ServiceProtocol) -> HeadersDict {
        var params: HeadersDict = service.headers
        self.headers?.forEach({ k,v in params[k] = v })
        return params
    }
    
    func url(in service: ServiceProtocol) throws -> URL {
        let baseURL = service.configuration.url.absoluteString.appending(self.endpoint)
        let fullURLString = try baseURL.fill(withValues: self.urlParams).stringByAdding(urlEncodedFields: self.fields)
        guard let url = URL(string: fullURLString) else {
            throw NetworkError.invalidURL(fullURLString)
        }
        return url
    }
    
    func urlRequest(in service: ServiceProtocol) throws -> URLRequest {
        let requestURL = try self.url(in: service)
        let cachePolicy = self.cashePolicy ?? service.configuration.cachePolicy
        let timeout = self.timeout ?? service.configuration.timeout
        let headers = self.headers(in: service)
        
        var urlRequest = URLRequest(url: requestURL, cachePolicy: cachePolicy, timeoutInterval: timeout)
        urlRequest.httpMethod = (self.method ?? .get).rawValue
        urlRequest.allHTTPHeaderFields = headers
        if let bodyData = try self.body?.encodedData() {
            urlRequest.httpBody = bodyData
        }
        return urlRequest
    }
    
}
