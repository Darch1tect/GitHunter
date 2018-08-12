//
//  Service.swift
//  ClientRedd
//
//  Created by Vitalii Roditieliev on 6/25/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import PromiseKit

public class Service: ServiceProtocol {
    
    public var configuration: ServiceConfiguration
    public var headers: HeadersDict
    
    public required init(_ configuration: ServiceConfiguration) {
        self.configuration = configuration
        self.headers = configuration.headers
    }
    
    
    private func makeUrlRequest (_ request: RequestProtocol) -> Promise<URLRequest> {
        return Promise<URLRequest> { seal in
            if let req: URLRequest = try? request.urlRequest(in: self) {
                seal.fulfill(req)
            } else {
                seal.reject(NetworkError.invalidURL("invalid URL"))
            }
        }
    }
    
    func attempt<T>(maxRetryCount: Int = 3, delayBeforeRetry: DispatchTimeInterval = .seconds(2),
                    _ body: Promise<T>) -> Promise<T> {
        var attempts = 0
        func attempt() -> Promise<T> {
            attempts += 1
            return body.recover { error -> Promise<T> in
                guard attempts < maxRetryCount else { throw error }
                return after(delayBeforeRetry).then(on: nil, attempt)
            }
        }
        return attempt()
    }
    
    public func execute(_ request: RequestProtocol, retry: Int?) -> Promise<ResponseProtocol> {
        let requestPromise = makeUrlRequest(request)
        let op = requestPromise.then(on: request.context?.queue) { urlRequest in
            URLSession.shared.dataTask(.promise, with: urlRequest)
            }.then { (data, response) -> Promise<ResponseProtocol> in
                let parsedResponse = Response(urlSessionResponse: response as! HTTPURLResponse, data: data, request: request)
               return Promise<ResponseProtocol> { seal  in
                    switch parsedResponse.type {
                    case .success:
                        seal.fulfill(parsedResponse)
                    case .error:
                        seal.reject(NetworkError.error(parsedResponse))
                    case .noResponse:
                        seal.reject(NetworkError.noResponse(parsedResponse))
                    }
                }
            }
        guard let retryAttempts = retry else { return op } // single attempt
        return attempt(maxRetryCount: retryAttempts, op)
        }
    
}

