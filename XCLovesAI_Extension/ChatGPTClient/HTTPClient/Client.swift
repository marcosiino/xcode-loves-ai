//
//  Client.swift
//  ChatGPT-Client
//
//  Created by Marco on 27/04/23.
//

import Foundation

enum ClientError: Error {
    case requestBodyEncodingError(String)
    case connectionError(String)
    case invalidResponse
    case responseBodyDecodingError(String)
}

class Client {
    private let session = URLSession.shared
    private let globalHeaders: [String: String]
    
    init(globalHeaders: [String: String] = [String:String]()) {
        self.globalHeaders = globalHeaders
    }
        
    func performRequest<ResponseModel: Decodable>(_ request: Request) async throws -> ResponseModel? {
        let urlReq = try makeURLRequest(with: request)
        
        return try await withCheckedThrowingContinuation { continuation in
            logRequest(request: request)
            
            session.dataTask(with: urlReq) { [weak self] data, response, error in
                self?.logResponse(for: request, data: data, response: response, error: error)
                
                guard error == nil else {
                    continuation.resume(throwing: ClientError.connectionError(error!.localizedDescription))
                    return
                }
                
                guard let _ = response as? HTTPURLResponse else {
                    continuation.resume(throwing: ClientError.invalidResponse)
                    return
                }
                
                if let data = data {
                    do {
                        let responseModel = try JSONDecoder().decode(ResponseModel.self, from: data)
                        continuation.resume(returning: responseModel)
                    }
                    catch(let error) {
                        continuation.resume(throwing: ClientError.responseBodyDecodingError(error.localizedDescription))
                    }
                }
                else {
                    continuation.resume(returning: nil)
                }
            }.resume()
        }
    }
    
    private func makeURLRequest(with req: any Request) throws -> URLRequest {
        var urlRequest = URLRequest(url: req.fullEndpointURL)
        
        urlRequest.httpMethod = req.method.rawValue
        urlRequest.allHTTPHeaderFields = fullHeaders(for: req)
        
        urlRequest.httpBody = req.body
        
        return urlRequest as URLRequest
    }
    
    /// Merge the global and request headers, and in case of duplicated keys uses the entries defined in the request headers.
    private func fullHeaders(for request: any Request) -> [String:String] {
        return globalHeaders.merging(request.headers, uniquingKeysWith: { (global, req) in return req })
    }
    
    private func logRequest(request: Request) {
        print("--------------------------   REQUEST   -----------------------")
        print("Request Name: \(type(of: request))")
        print("Endpoint: \(request.fullEndpointURL)")
        
        print("Headers:")
        print(fullHeaders(for: request))
        
        print("Request Body:")
        if let data = request.body, let strBody = String(data:data, encoding: .utf8) {
            print(strBody)
        }
        else {
            print("- No body -")
        }
        
        print("-------------------------- END REQUEST -----------------------")
    }
    
    private func logResponse(for request: Request, data: Data?, response: URLResponse?, error: Error?) {
        print("--------------------------   RESPONSE   -----------------------")
        defer {
            print("-------------------------- END RESPONSE -----------------------")
        }
        
        print("Request Name: \(type(of: request))")
        print("Endpoint: \(request.fullEndpointURL)")
        
        guard error == nil else {
            print("** Connection Error **:")
            print(error!.localizedDescription)
            return
        }
        
        if let response = response as? HTTPURLResponse {
            print("Status Code: \(response.statusCode)")
            
            print("Headers:")
            print(response.allHeaderFields)
        }
        
        print("Response Body:")
        if let data = data, let strBody = String(data:data, encoding: .utf8) {
            print(strBody)
        }
        else {
            print("- No body -")
        }
    }
}
