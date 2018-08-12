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
//    var metrics: ResponseTimeline? { get } // TEMPORALY
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


/*
@interface NSURLSessionTaskTransactionMetrics14 : NSObject
/*
 * Represents the transaction request.
 */
@property (copy, readonly) NSURLRequest *request;

/*
 * Represents the transaction response. Can be nil if error occurred and no response was generated.
 */
@property (nullable, copy, readonly) NSURLResponse *response;

/*
 * For all NSDate metrics below, if that aspect of the task could not be completed, then the corresponding “EndDate” metric will be nil.
 * For example, if a name lookup was started but the name lookup timed out, failed, or the client canceled the task before the name could be resolved -- then while domainLookupStartDate may be set, domainLookupEndDate will be nil along with all later metrics.
 */

/*
 * fetchStartDate returns the time when the user agent started fetching the resource, whether or not the resource was retrieved from the server or local resources.
 *
 * The following metrics will be set to nil, if a persistent connection was used or the resource was retrieved from local resources:
 *
 *   domainLookupStartDate
 *   domainLookupEndDate
 *   connectStartDate
 *   connectEndDate
 *   secureConnectionStartDate
 *   secureConnectionEndDate
 */
@property (nullable, copy, readonly) NSDate *fetchStartDate;

/*
 * domainLookupStartDate returns the time immediately before the user agent started the name lookup for the resource.
 */
@property (nullable, copy, readonly) NSDate *domainLookupStartDate;

/*
 * domainLookupEndDate returns the time after the name lookup was completed.
 */
@property (nullable, copy, readonly) NSDate *domainLookupEndDate;

/*
 * connectStartDate is the time immediately before the user agent started establishing the connection to the server.
 *
 * For example, this would correspond to the time immediately before the user agent started trying to establish the TCP connection.
 */
@property (nullable, copy, readonly) NSDate *connectStartDate;

/*
 * If an encrypted connection was used, secureConnectionStartDate is the time immediately before the user agent started the security handshake to secure the current connection.
 *
 * For example, this would correspond to the time immediately before the user agent started the TLS handshake.
 *
 * If an encrypted connection was not used, this attribute is set to nil.
 */
@property (nullable, copy, readonly) NSDate *secureConnectionStartDate;

/*
 * If an encrypted connection was used, secureConnectionEndDate is the time immediately after the security handshake completed.
 *
 * If an encrypted connection was not used, this attribute is set to nil.
 */
@property (nullable, copy, readonly) NSDate *secureConnectionEndDate;

/*
 * connectEndDate is the time immediately after the user agent finished establishing the connection to the server, including completion of security-related and other handshakes.
 */
@property (nullable, copy, readonly) NSDate *connectEndDate;

/*
 * requestStartDate is the time immediately before the user agent started requesting the source, regardless of whether the resource was retrieved from the server or local resources.
 *
 * For example, this would correspond to the time immediately before the user agent sent an HTTP GET request.
 */
@property (nullable, copy, readonly) NSDate *requestStartDate;

/*
 * requestEndDate is the time immediately after the user agent finished requesting the source, regardless of whether the resource was retrieved from the server or local resources.
 *
 * For example, this would correspond to the time immediately after the user agent finished sending the last byte of the request.
 */
@property (nullable, copy, readonly) NSDate *requestEndDate;

/*
 * responseStartDate is the time immediately after the user agent received the first byte of the response from the server or from local resources.
 *
 * For example, this would correspond to the time immediately after the user agent received the first byte of an HTTP response.
 */
@property (nullable, copy, readonly) NSDate *responseStartDate;

/*
 * responseEndDate is the time immediately after the user agent received the last byte of the resource.
 */
@property (nullable, copy, readonly) NSDate *responseEndDate;

/*
 * The network protocol used to fetch the resource, as identified by the ALPN Protocol ID Identification Sequence [RFC7301].
 * E.g., h2, http/1.1, spdy/3.1.
 *
 * When a proxy is configured AND a tunnel connection is established, then this attribute returns the value for the tunneled protocol.
 *
 * For example:
 * If no proxy were used, and HTTP/2 was negotiated, then h2 would be returned.
 * If HTTP/1.1 were used to the proxy, and the tunneled connection was HTTP/2, then h2 would be returned.
 * If HTTP/1.1 were used to the proxy, and there were no tunnel, then http/1.1 would be returned.
 *
 */
@property (nullable, copy, readonly) NSString *networkProtocolName;

/*
 * This property is set to YES if a proxy connection was used to fetch the resource.
 */
@property (assign, readonly, getter=isProxyConnection) BOOL proxyConnection;

/*
 * This property is set to YES if a persistent connection was used to fetch the resource.
 */
@property (assign, readonly, getter=isReusedConnection) BOOL reusedConnection;

/*
 * Indicates whether the resource was loaded, pushed or retrieved from the local cache.
 */
@property (assign, readonly) NSURLSessionTaskMetricsResourceFetchType resourceFetchType;

@end
*/
