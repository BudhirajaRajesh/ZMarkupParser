//
//  ZHTMLParser+UIExtension.swift
//  
//
//  Created by https://zhgchg.li on 2023/2/17.
//

import Foundation
import UIKit

public extension UITextView {
    func setHtmlString(_ string: String, with parser: ZHTMLParser, forceDecodeHTMLEntities: Bool = true) {
        self.setHtmlString(NSAttributedString(string: string), with: parser, forceDecodeHTMLEntities: forceDecodeHTMLEntities)
    }
    
    func setHtmlString(_ string: NSAttributedString, with parser: ZHTMLParser, forceDecodeHTMLEntities: Bool = true) {
        self.attributedText = parser.render(string, forceDecodeHTMLEntities: forceDecodeHTMLEntities)
        self.linkTextAttributes = parser.linkTextAttributes
    }
    
    func setHtmlString(_ string: String, with parser: ZHTMLParser, forceDecodeHTMLEntities: Bool = true, completionHandler: ((NSAttributedString) -> Void)? = nil) {
        self.setHtmlString(NSAttributedString(string: string), with: parser, forceDecodeHTMLEntities: forceDecodeHTMLEntities, completionHandler: completionHandler)
    }
    
    func setHtmlString(_ string: NSAttributedString, with parser: ZHTMLParser, forceDecodeHTMLEntities: Bool = true, completionHandler: ((NSAttributedString) -> Void)? = nil) {
        parser.render(string, forceDecodeHTMLEntities: forceDecodeHTMLEntities) { attributedString in
            self.attributedText = attributedString
            self.linkTextAttributes = parser.linkTextAttributes
            completionHandler?(attributedString)
        }
    }
}

public extension UILabel {
    func setHtmlString(_ string: String, with parser: ZHTMLParser) {
        self.setHtmlString(NSAttributedString(string: string), with: parser)
    }
    
    func setHtmlString(_ string: NSAttributedString, with parser: ZHTMLParser) {
        let attributedString = parser.render(string)
        attributedString.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, attributedString.string.utf16.count), options: []) { (value, effectiveRange, nil) in
            guard let attachment = value as? ZNSTextAttachmentCore else {
                return
            }
            
            attachment.register(self)
        }
        
        self.attributedText = attributedString
    }
    
    func setHtmlString(_ string: String, with parser: ZHTMLParser, completionHandler: ((NSAttributedString) -> Void)? = nil) {
        self.setHtmlString(NSAttributedString(string: string), with: parser, completionHandler: completionHandler)
    }
    
    func setHtmlString(_ string: NSAttributedString, with parser: ZHTMLParser, completionHandler: ((NSAttributedString) -> Void)? = nil) {
        parser.render(string) { attributedString in
            attributedString.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, attributedString.string.utf16.count), options: []) { (value, effectiveRange, nil) in
                guard let attachment = value as? ZNSTextAttachmentCore else {
                    return
                }
                
                attachment.register(self)
            }
            
            self.attributedText = attributedString
            completionHandler?(attributedString)
        }
    }
}
