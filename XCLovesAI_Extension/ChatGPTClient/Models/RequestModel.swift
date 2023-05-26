//
//  RequestModel.swift
//  ChatGPT-Client
//
//  Created by Marco on 27/04/23.
//

import Foundation
struct RequestModel: Encodable {
    enum GPTModel: String, Encodable {
        case gpt3_5Turbo = "gpt-3.5-turbo"
        case gpt4 = "gpt-4"
    }
    
    let model: GPTModel
    let messages: [MessageModel]
}
