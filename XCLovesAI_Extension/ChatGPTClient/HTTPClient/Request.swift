//
//  Request.swift
//  ChatGPT-Client
//
//  Created by Marco on 27/04/23.
//

import Foundation

enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Request {
    var method: Method { get }
    var baseURL: URL { get }
    var endpoint: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}

extension Request {
    var fullEndpointURL: URL {
        return baseURL.appending(path: endpoint)
    }
}
