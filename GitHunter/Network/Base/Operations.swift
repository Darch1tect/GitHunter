//
//  Operations.swift
//  ClientRedd
//
//  Created by Vitalii Roditieliev on 7/17/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

open class DataOperation<ResponseProtocol>: OperationProtocol {
    
    typealias T = ResponseProtocol
    
    public var request: RequestProtocol?
    
    public init() { }
    
    public func execute(in service: ServiceProtocol, retry: Int?) -> Promise<ResponseProtocol> {
        return Promise<ResponseProtocol> { seal in
            guard let req = self.request else {
                seal.reject(NetworkError.missingEndpoint)
                return
            }
            service.execute(req, retry: retry).then({ dataResponse -> Promise<ResponseProtocol> in
                let x: ResponseProtocol = dataResponse as! ResponseProtocol
                return .value(x)
            }).catch({ error in
                print("Unexpected response error")
            })
        }
    }
    
}

open class JSONOperation<Output>: OperationProtocol {
  
    typealias T = Output
    
    public var request: RequestProtocol?
    
    public var onParseResponse: ((JSON) throws -> (Output))? = nil
    
    public init() {
        self.onParseResponse = { _ in
            fatalError("Method onParseResponse must be implemented in subclass to return correct <Output> from JSONOperation")
        }
    }
    
    public func execute(in service: ServiceProtocol, retry: Int?) -> Promise<Output> {
        return Promise<Output> { seal in
            guard let req = self.request else {
                seal.reject(NetworkError.missingEndpoint)
                return
            }
            service.execute(req, retry: retry).then({ response -> Promise<Output> in
                let json = response.toJSON()
                do {
                    let parsedObj = try self.onParseResponse!(json)
                    seal.fulfill(parsedObj)
                    return .value(parsedObj)
                } catch {
                    throw NetworkError.failedToParseJSON(json, response)
                }
            }).catch({ error in
                print("Unexpected json parsing error")
            })
        }
    }
}

