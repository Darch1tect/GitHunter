//
//  Request.swift
//  ClientRedd
//
//  Created by Vitalii Roditieliev on 7/11/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Request: RequestProtocol {
    public var context: Context?
    
    public var invalidationToken: InvalidationToken?
    public var endpoint: String
    public var body: RequestBody?
    public var method: RequestMethod?
    public var fields: ParametersDict?
    public var urlParams: ParametersDict?
    public var headers: HeadersDict?
    public var cashePolicy: URLRequest.CachePolicy?
    public var timeout: TimeInterval?
    
    public init(method: RequestMethod = .get, endpoint: String = "", params: ParametersDict? = nil, fields: ParametersDict? = nil, body: RequestBody? = nil) {
        self.method = method
        self.endpoint = endpoint
        self.urlParams = params
        self.fields = fields
        self.body = body
    }
}

// MARK: - Request commons

public enum RequestMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
}

public struct RequestBody {
    let data: Any
    let encoding: Encoding
    
    // Encoding type
    //
    // - raw: no encoding, data is sent as received
    // - json: json encoding
    // - urlEncoded: url encoded string
    // - custom: custom serialized data
    public enum Encoding {
        case rawData
        case rawString(_: String.Encoding?)
        case json
        case urlEncoded(_: String.Encoding?)
        case custom(_: CustomEncoder)
        
        public typealias CustomEncoder = ((Any) -> (Data))
    }
    
    // Private initializer for request body
    private init(_ data: Any, as encoding: Encoding = .json) {
        self.data = data
        self.encoding = encoding
    }
    
    // For creating a new body which will be encoded as JSON
    // - Parameter data: any serializable to JSON object
    // - Returns: RequestBody
    public static func json(_ data: Any) -> RequestBody {
        return RequestBody(data, as: .json)
    }
    
    // For creating a new body which will be encoded as url encoded string
    // - Parameters:
    //   - data: a string of encodable data as url
    //   - encoding: encoding type to transform the string into data
    // - Returns: RequestBody
    public static func urlEncoded(_ data: ParametersDict, encoding: String.Encoding? = .utf8) -> RequestBody {
        return RequestBody(data, as: .urlEncoded(encoding))
    }
    
    // For creating a new body which will be sent in raw form
    // - Parameter data: data to send
    // - Returns: RequestBody
    public static func raw(data: Data) -> RequestBody {
        return RequestBody(data, as: .rawData)
    }
    
    // For creating a new body which will be sent as plain string encoded as you set
    // - Parameter data: data to send
    // - Returns: RequestBody
    public static func raw(string: String, encoding: String.Encoding? = .utf8) -> RequestBody {
        return RequestBody(string, as: .rawString(encoding))
    }
    
    // For creating a new body which will be encoded with a custom function.
    // - Parameters:
    //   - data: data to encode
    //   - encoder: encoder function
    // - Returns: RequestBody
    public static func custom(_ data: Data, encoder: @escaping Encoding.CustomEncoder) -> RequestBody {
        return RequestBody(data, as: .custom(encoder))
    }
    
    public func encodedData() throws -> Data {
        switch self.encoding {
        case .rawData:
            return self.data as! Data
            
        case .rawString(let encoding):
            guard let string = (self.data as! String).data(using: encoding ?? .utf8) else {
                throw NetworkError.dataNotEncodable(self.data)
            }
            return string
            
        case .json:
            return try JSONSerialization.data(withJSONObject: self.data, options: [])
            
        case .urlEncoded(let encoding):
            let encodedString = try (self.data as! ParametersDict).urlEncodedString()
            guard let data = encodedString.data(using: encoding ?? .utf8) else {
                throw NetworkError.dataNotEncodable(encodedString)
            }
            return data
            
        case .custom(let encodingFunc):
            return encodingFunc(self.data)
        }
    }
    
    public func encodedString(_ encoding: String.Encoding = .utf8) throws -> String {
        let encodedData = try self.encodedData()
        guard let stringRepresentation = String(data: encodedData, encoding: encoding) else {
            throw NetworkError.stringFailedToDecode(encodedData, encoding: encoding)
        }
        return stringRepresentation
    }
}
