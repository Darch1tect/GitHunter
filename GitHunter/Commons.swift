//
//  Commons.swift
//  ClientRedd
//
//  Created by Vitalii Roditieliev on 6/23/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import SwiftyJSON

public typealias HeadersDict = [String: String]
public typealias ParametersDict = [String : Any?]

public struct Constants {
    /// This represent keys used into the Info.plist file of the app.
    /// The root node is `endpoint` with `base`, `pathAPI` and `name` inside which contains
    /// the server configuration.
    ///
    /// - endpoint: endpoint
    /// - base: base
    /// - pathAPI: api service path
    /// - name: name of the configuration
    /// - headers: global headers to include in a service base configuration
    
    public enum ServerConfig: String {
        case endpoint   =   "Endpoint"
        case base       =   "base"
        case pathAPI    =   "path"
        case name       =   "name"
        case headers    =   "headers"
    }
    
    /// Maybe no need ????
    private init() {}
}

public enum NetworkError: Error {
    case dataNotEncodable(_: Any)
    case stringFailedToDecode(_: Data, encoding: String.Encoding)
    case invalidURL(_: String)
    case missingEndpoint
    case error(_: ResponseProtocol)
    case noResponse(_: ResponseProtocol)
    case failedToParseJSON(_: JSON, _: ResponseProtocol)
}

public protocol InvalidatableProtocol {
    
    /// Set to `true` in order to receive the message from the inside the Promise's body.
    var isCancelled: Bool { get }
    
}

/// Simple implementation of the `InvalidatableProtocol` protocol.
/// Could be extended in future to provide specific bussiness logic
open class InvalidationToken: InvalidatableProtocol {
    
    /// Current status of the promise
    public var isCancelled: Bool = false
    
    /// Call this function to mark the operation as invalid.
    public func invalidate() {
        isCancelled = true
    }
    
    /// Public init
    public init() { }
}

// Some simple wrapper around GCD
public enum Context {
    case main
    case userInteractive
    case userInitiated
    case utility
    case background
    case custom(queue: DispatchQueue)
    
    public var queue: DispatchQueue {
        switch self {
        case .main: return .main
        case .userInteractive: return .global(qos: .userInteractive)
        case .userInitiated: return .global(qos: .userInitiated)
        case .utility: return .global(qos: .utility)
        case .background: return .global(qos: .background)
        case .custom(let queue): return queue
        }
    }
}
