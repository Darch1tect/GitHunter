//
//  Response.swift
//  ClientRedd
//
//  Created by Vitalii Roditieliev on 7/13/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Response: ResponseProtocol {
    
    public enum Result {
        case success(_: Int)
        case error(_: Int)
        case noResponse
        
        private static let successCodes: Range<Int> = 200..<299
        
        public static func from(response: HTTPURLResponse?) -> Result {
            guard let r = response else { return .noResponse }
            return (Result.successCodes.contains(r.statusCode) ? .success(r.statusCode) : .error(r.statusCode))
        }
        
        public var code: Int? {
            switch self {
            case .success(let code):
                return code
            case .error(let code):
                return code
            case .noResponse:
                return nil
            }
        }
    }
    
    // type of result
    public let type: Response.Result
    public let httpResponse: HTTPURLResponse?
    
    public var httpStatusCode: Int? {
        return self.type.code
    }
    
    public var data: Data?
    public var request: RequestProtocol
    public var metrics: ResponseTimeline?
    
    public init(urlSessionResponse response: HTTPURLResponse, data: Data?, request: RequestProtocol) {
        self.type = Result.from(response: response)
        self.httpResponse = response
        self.data = data
        self.request = request
//        self.metrics = response.time
    }
    
    private lazy var cachedJSON: JSON = {
        let json = try? JSON(data: self.data ?? Data())
        return json!
    }()
    
    public func toJSON() -> JSON {
        return self.cachedJSON
    }
    
    public func toString(_ encoding: String.Encoding?) -> String? {
        guard let d = self.data else { return nil }
        return String(data: d, encoding: encoding ?? .utf8)
    }
    
}
