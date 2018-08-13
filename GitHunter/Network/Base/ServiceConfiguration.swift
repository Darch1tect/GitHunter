//
//  ServiceConfiguration.swift
//  ClientRedd
//
//  Created by Vitalii Roditieliev on 6/23/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ServiceConfiguration: CustomStringConvertible, Equatable {
    
    private(set) var name: String
    private(set) var url: URL
    private(set) var headers: HeadersDict = [:]
    
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    public var timeout: TimeInterval = 15.0
    
    public init?(name: String? = nil, base urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.url = url
        self.name = name ?? (url.host ?? "")
    }
    
    public static func appConfig() -> ServiceConfiguration? {
        return ServiceConfiguration()
    }
    
    public convenience init?() {
        let appConfig = JSON(Bundle.main.object(forInfoDictionaryKey: Constants.ServerConfig.endpoint.rawValue) as Any)
        guard let base = appConfig[Constants.ServerConfig.base.rawValue].string else { return nil }
        
        // Initialization with params
        self.init(name: appConfig[Constants.ServerConfig.name.rawValue].stringValue, base: base)
        
        // Attempt to read a list of headers from configuration
        if let fixedHeaders = appConfig[Constants.ServerConfig.headers.rawValue].dictionaryObject as? HeadersDict {
            self.headers = fixedHeaders
        }
    }
    
    // MARK: - CustomStringConvertible
    public var description: String {
        return "\(self.name): \(self.url.absoluteString)"
    }
    
    //MARK: - Equatable
    public static func ==(lhs: ServiceConfiguration, rhs: ServiceConfiguration) -> Bool {
        return lhs.url.absoluteString.lowercased() == rhs.url.absoluteString.lowercased()
    }
}


