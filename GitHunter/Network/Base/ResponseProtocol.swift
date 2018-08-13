//
//  ResponseProtocol.swift
//  ClientRedd
//
//  Created by Vitalii Roditieliev on 7/13/18.
//  Copyright © 2018 Vitalii Roditieliev. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol ResponseProtocol {
    
    var type: Response.Result { get }
//    var metrics: ResponseTimeline? { get } // TEMPORALY, will be implemented in future
    var request: RequestProtocol { get }
    var httpResponse: HTTPURLResponse? { get }
    var httpStatusCode: Int? { get }
    var data: Data? { get }
    
    func toJSON() -> JSON
    func toString(_ encoding: String.Encoding?) -> String?
}

public protocol ResponseTimeline: CustomStringConvertible {
    
    var requestStartTime: CFAbsoluteTime { get }
    var initialResponseTime: CFAbsoluteTime { get }
    var requsetCompletedTime: CFAbsoluteTime { get }
    var latency: TimeInterval { get }
    var requestDuration: TimeInterval { get }
    var totalDuration: TimeInterval { get }
}
