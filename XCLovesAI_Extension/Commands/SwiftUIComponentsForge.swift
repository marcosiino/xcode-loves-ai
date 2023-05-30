//
//  SwiftUIComponentsForge.swift
//  AIAssistant
//
//  Created by Marco on 30/05/23.
//  Copyright © 2023 Marco Siino. All rights reserved.
//

import Foundation
import XcodeKit

class SwiftUIComponentsForge: NSObject, XCSourceEditorCommand, CodeEditorCommand, AIAssistedCommand {
    var messages: [MessageModel] = []
    var client = ChatGPTClient(apiKey: SourceEditorExtension.apiKey)
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        //Using the whole source file as input, no selection required
        let inputText = invocation.buffer.completeBuffer
        
        addAIInstructions(systemInstructions: "You are a creative SwiftUI developer who can craft amazing SwiftUI reusable components with beautiful, original and creative look and animations. Generate a SwiftUI component for me and write a description of the component at the beginning of the code as comment, and document the code as well. Please include import SwiftUI and be sure to generate the swiftui preview too. Doesn't write other text other than code and comments. Surprise me!")
        addAIMessageWithCode(code: inputText)
        
        Task {
            do {
                if let generatedAnswer = try await sendRequestToAI() {
                    invocation.buffer.completeBuffer = generatedAnswer
                }
                completionHandler(nil)
            }
        }
    }
}
