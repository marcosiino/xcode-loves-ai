//
//  ChatRequest.swift
//  ChatGPT-Client
//
//  Created by Marco on 27/04/23.
//

import Foundation

struct ChatRequest: Request {
    let gptModel: RequestModel.GPTModel
    let messages: [MessageModel]
    
    let baseURL: URL = URL(string: "https://api.openai.com/v1/")!
    let headers = [String: String]()
    var method: Method { .post }
    var endpoint: String { "chat/completions" }
    
    var body: Data? {
        let requestModel = RequestModel(model: gptModel,
                                        messages: messages)
        return try? JSONEncoder().encode(requestModel)
    }
    
    init(gptModel: RequestModel.GPTModel = .gpt3_5Turbo, messages: [MessageModel]) {
        self.gptModel = gptModel
        self.messages = messages
    }
}
