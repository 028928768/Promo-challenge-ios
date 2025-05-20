//
//  HTMLView.swift
//  primo-challenge-ios
//
//  Created by Simon SIwell on 20/5/2568 BE.
//

import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {
    let htmlContent: String
    @Binding var contentHeight: CGFloat

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(styledHTML(htmlContent), baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    private func styledHTML(_ rawHTML: String) -> String {
        let style = """
        <style>
            body {
                font-size: 16px;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen,
                             Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
                color: #222222;
                line-height: 1.5;
                padding: 10px;
                margin: 0;
            }
            img {
                max-width: 100%;
                height: auto;
                display: block;
                margin: 10px 0;
            }
            figure {
                margin: 0;
            }
        </style>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
        """
        return "<html><head>\(style)</head><body>\(rawHTML)</body></html>"
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HTMLView

        init(parent: HTMLView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Poll content height multiple times to get stable value
            updateHeight(webView)
        }

        private func updateHeight(_ webView: WKWebView, attempts: Int = 3) {
            guard attempts > 0 else { return }
            webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] (height, error) in
                if let height = height as? CGFloat {
                    DispatchQueue.main.async {
                        self?.parent.contentHeight = height
                    }
                    // Try again shortly to ensure height stability
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.updateHeight(webView, attempts: attempts - 1)
                    }
                }
            }
        }
    }
}



