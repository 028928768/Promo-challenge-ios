//
//  String+Extension.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import Foundation

extension String {
    /// Cleans HTML content by removing specific tags and extracting the first paragraph.
    var cleanedSummary: String {
        var html = self

        // Remove <script> and <style> tags and their content
        html = html.replacingOccurrences(of: "<(script|style)[\\s\\S]*?</\\1>", with: "", options: .regularExpression)

        // Remove <figure> tags and their content
        html = html.replacingOccurrences(of: "<figure[\\s\\S]*?</figure>", with: "", options: .regularExpression)

        // Remove <img> tags
        html = html.replacingOccurrences(of: "<img[^>]*>", with: "", options: .regularExpression)

        // Extract the first <p>...</p> block
        if let paragraphRange = html.range(of: "<p[\\s\\S]*?</p>", options: .regularExpression) {
            html = String(html[paragraphRange])
        }

        // Convert HTML to plain text
        guard let data = html.data(using: .utf8) else { return self }
        do {
            let attributed = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            return attributed.string.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            return self
        }
    }
}


