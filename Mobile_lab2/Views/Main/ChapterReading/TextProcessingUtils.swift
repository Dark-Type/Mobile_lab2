//
//  TextProcessingUtils.swift
//  Mobile_lab2
//
//  Created by dark type on 25.03.2025.
//

import SwiftUI

enum TextProcessingUtils {
    static func splitIntoSentences(_ text: String) -> [String] {
        let pattern = "([.!?](?:\\s|$))"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        var sentences: [String] = []
        var lastEnd = 0
        if let regex = regex {
            let nsString = text as NSString
            let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            for match in matches {
                let sentenceEnd = match.range.location + match.range.length
                let sentenceRange = NSRange(location: lastEnd, length: sentenceEnd - lastEnd)
                sentences.append(nsString.substring(with: sentenceRange))
                lastEnd = sentenceEnd
            }
            if lastEnd < nsString.length {
                sentences.append(nsString.substring(with: NSRange(location: lastEnd, length: nsString.length - lastEnd)))
            }
        } else {
            sentences = [text]
        }
        return sentences.filter { !$0.isEmpty }
    }

    static func highlightedText(_ paragraph: String, sentenceIndex: Int, fontSize: CGFloat, accentDarkColor: Color, secondaryColor: Color) -> AttributedString {
        var result = AttributedString(paragraph)
        result.font = .custom("Georgia", size: fontSize)
        result.foregroundColor = accentDarkColor
        if sentenceIndex < 0 {
            return result
        }
        let sentences = splitIntoSentences(paragraph)
        guard sentences.count > sentenceIndex else {
            return result
        }
        var startIndex = 0
        for i in 0 ..< sentenceIndex where i < sentences.count {
            startIndex += sentences[i].count
        }
        let currentSentence = sentences[sentenceIndex]
        let endIndex = startIndex + currentSentence.count

        guard startIndex < paragraph.count && endIndex <= paragraph.count else {
            return result
        }
        let utf16StartIndex = paragraph.utf16.distance(from: paragraph.startIndex,
                                                       to: paragraph.index(paragraph.startIndex, offsetBy: startIndex))
        let utf16EndIndex = paragraph.utf16.distance(from: paragraph.startIndex,
                                                     to: paragraph.index(paragraph.startIndex, offsetBy: endIndex))
        let range = NSRange(location: utf16StartIndex, length: utf16EndIndex - utf16StartIndex)
        if let attributedStringRange = Range(range, in: result) {
            result[attributedStringRange].foregroundColor = secondaryColor
        }
        return result
    }

    static func calculateReadingTime(for sentence: String) -> TimeInterval {
        let wordCount = sentence.split(separator: " ").count
        let wordsPerMinute: Double = 180
        let minutes = Double(wordCount) / wordsPerMinute
        return max(minutes * 60, 0.8)
    }
}
