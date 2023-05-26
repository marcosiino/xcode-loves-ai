//
//  ResponseModel.swift
//  ChatGPT-Client
//
//  Created by Marco on 27/04/23.
//

import Foundation

struct ResponseModel: Decodable {
    struct Choice: Decodable {
        let index: Int
        let message: MessageModel
        let finishReason: String
        
        enum CodingKeys: String, CodingKey {
            case index, message
            case finishReason = "finish_reason"
        }
    }
    
    struct Usage: Decodable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }
    
    let id: String
    let object: String
    let created: Date
    let choices: [Choice]
}
