//
//  Extensions.swift
//  ClientRedd
//
//  Created by Vitalii Roditieliev on 7/11/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation

// MARK: - Dictionary Extension

public extension Dictionary where Key == String, Value == Any? {
    
    // Encode a dictionary as url encoded string
    //
    // - Parameter base: base url
    // - Returns: encoded string
    // - Throws: throw `.dataIsNotEncodable` if data cannot be encoded
    public func urlEncodedString(base: String = "") throws -> String {
        guard self.count > 0 else { return "" } // nothing to encode
        let items: [URLQueryItem] = self.compactMap { (key, value) in
            guard let v = value else { return nil } //skip item if no value is set
            return URLQueryItem(name: key, value: String(describing: v))
        }
        var urlComponents = URLComponents(string: base)!
        urlComponents.queryItems = items
        guard let encodedString = urlComponents.url else {
            throw NetworkError.dataNotEncodable(self)
        }
        return encodedString.absoluteString
    }
}

// MARK: - String Extension

public extension String {
    
    /// Fill up a string by replacing values in specified placeholders
    ///
    /// - Parameter dict: dict to use
    /// - Returns: replaced string
    public func fill(withValues dict: [String: Any?]?) -> String {
        guard let data = dict else {
            return self
        }
        var finalString = self
        data.forEach { arg in
            if let unwrappedValue = arg.value {
                finalString = finalString.replacingOccurrences(of: "{\(arg.key)}", with: String(describing: unwrappedValue))
            }
        }
        return finalString
    }
    
    public func stringByAdding(urlEncodedFields fields: ParametersDict?) throws -> String {
        guard let f = fields else { return self }
        return try f.urlEncodedString(base: self)
    }
    
    public func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
}
