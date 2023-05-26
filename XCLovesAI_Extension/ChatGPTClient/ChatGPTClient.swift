//
//  ChatGPTClient.swift
//  ChatGPT-Client
//
//  Created by Marco on 27/04/23.
//

import Foundation

class ChatGPTClient: Client {
    private let model: RequestModel.GPTModel
    
    init(apiKey: String, model: RequestModel.GPTModel = .gpt3_5Turbo) {
        self.model = model
        super.init(globalHeaders: [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ])
    }
    
    func sendMessages(messages: [MessageModel]) async throws -> ResponseModel? {
        let request = ChatRequest(gptModel: model, messages: messages)
        return try await performRequest(request)
    }
}
