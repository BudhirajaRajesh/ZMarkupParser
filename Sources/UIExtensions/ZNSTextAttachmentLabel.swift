//
//  ZNSTextAttachmentLabel.swift
//  
//
//  Created by https://zhgchg.li on 2023/3/5.
//

import Foundation
import UIKit

public class ZNSTextAttachmentLabel: UILabel {
    public override var attributedText: NSAttributedString? {
        didSet {
            attributedText?.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, attributedText?.string.utf16.count ?? 0), options: []) { (value, effectiveRange, nil) in
                guard let attachment = value as? ZNSTextAttachmentCore else {
                    return
                }
                
                attachment.register(self)
            }
        }
    }
}
