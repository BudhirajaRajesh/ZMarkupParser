//
//  ImageMarkup.swift
//  
//
//  Created by zhgchgli on 2023/3/1.
//

import Foundation

final class ImageMarkup: Markup {

    let attachment: ZNSTextAttachmentCore
    let width: CGFloat?
    let height: CGFloat?
    
    init(attachment: ZNSTextAttachmentCore, width: CGFloat?, height: CGFloat?) {
        self.attachment = attachment
        self.width = width
        self.height = height
    }
    
    weak var parentMarkup: Markup? = nil
    var childMarkups: [Markup] = []
    
    func accept<V>(_ visitor: V) -> V.Result where V : MarkupVisitor {
        return visitor.visit(self)
    }
}
