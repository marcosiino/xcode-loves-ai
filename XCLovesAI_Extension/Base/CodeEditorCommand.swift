//
//  CodeEditorCommand.swift
//  XCLovesAI_Extension
//
//  Created by Marco on 25/05/23.
//  Copyright © 2023 Marco Siino. All rights reserved.
//

import Foundation
import XcodeKit

protocol CodeEditorCommand {
    typealias SelectedTextBlock = (selectedText: String, indentation: String, startLine: Int, endLine: Int)
    
    /// Returns the selected text and its indentation
    func selectedTextBlock(from invocation: XCSourceEditorCommandInvocation) -> SelectedTextBlock?
}

extension CodeEditorCommand {
    func selectedTextBlock(from invocation: XCSourceEditorCommandInvocation) -> SelectedTextBlock? {
        guard let selections = invocation.buffer.selections as? [XCSourceTextRange],
              let selection = selections.first else {
            return nil
        }
        
        let startLine = selection.start.line
        var endLine = selection.end.line
        
        //For some reason, if you make a selection from some point until the last line in xcode, the invocation returns an invalid endLine (equal to the count of the total lines, instead of a 0-based one)... in this case i fix it by subtracting 1 to endLine
        if endLine == invocation.buffer.lines.count {
            endLine = endLine - 1
        }
        
        print("Start Line: \(startLine), end line: \(endLine), total lines count: \(invocation.buffer.lines.count)")
        
        //Extracts the selected lines of the from the entire source code
        var selectedTextBlock = ""
        for lineIndex in (startLine..<endLine) {
            if let line = invocation.buffer.lines[lineIndex] as? String {
                selectedTextBlock = selectedTextBlock + line
            }
        }
        
        //Gets the indentation from the first selected line of code
        var indentation = ""
        if let firstLine = invocation.buffer.lines[startLine] as? String {
            indentation = String(firstLine.prefix { $0.isWhitespace })
        }
        
        return (selectedTextBlock, indentation, startLine, endLine)
    }
}
