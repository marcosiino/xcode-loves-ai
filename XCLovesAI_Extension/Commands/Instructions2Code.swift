//
//  Instructions2Code.swift
//  XCLovesAI_Extension
//
//  Created by Marco on 26/05/23.
//  Copyright © 2023 Marco Siino. All rights reserved.
//

import Foundation
import XcodeKit
import AppKit

class Instructions2Code: NSObject, XCSourceEditorCommand, CodeEditorCommand, AIAssistedCommand {
    var messages: [MessageModel] = []
    var client = ChatGPTClient(apiKey: SourceEditorExtension.apiKey, model: .gpt3_5Turbo)
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        //Get the user selected code
        guard let selectedBlock = selectedTextBlock(from: invocation) else {
            completionHandler(nil)
            return
        }
        
        //Instructions for ChatGPT about the task to perform with our code
        addAIInstructions(systemInstructions: "You are a code generation assistant for Xcode. I will give you some instructions via comments and you will replace them with actual code based on those instructions. Answer only with the raw code, without any markup language or text instructions. Only output executable code. Write the full code.")
        
        //The code to send to chatgpt
        addAIMessageWithCode(code: selectedBlock.selectedText)
        
        Task {
            do {
                //Make the ChatGPT request
                if var generatedAnswer = try await sendRequestToAI() {
                    //Removes the markup code from the generated answer
                    generatedAnswer = generatedAnswer.replacingOccurrences(of: "```", with: "")
                    
                    for _ in (selectedBlock.startLine...selectedBlock.endLine) {
                        print("Removing line at: \(selectedBlock.startLine)")
                        invocation.buffer.lines.removeObject(at: selectedBlock.startLine)
                    }
                    
                    var insertAt = selectedBlock.startLine
                    for generatedLine in generatedAnswer.split(separator: "\n") {
                        //Add each generated line at the position where the user selections started, and adds the original indentation in the first line of the user selection so that the generated answer starting at the same indentation level of the code in the user selection
                        let indentedLine = selectedBlock.indentation + generatedLine
                        invocation.buffer.lines.insert(indentedLine, at: insertAt)
                        insertAt += 1
                    }
                }
                
                completionHandler(nil)
            }
        }
    }
}
