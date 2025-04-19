//
//  MarkupStyleColorTests.swift
//  
//
//  Created by https://zhgchg.li on 2023/2/18.
//

import Foundation
@testable import ZMarkupParser
import XCTest
import UIKit
// helper: https://www.uicolor.io
final class MarkupStyleColorTests: XCTestCase {
    
    func testInitStyleFromSponsorPinkoiColor() throws {
        let allCases = MarkupStyleSponsorColor.PinkoiColor.allCases
        for colorName in allCases {
            let sponsor = MarkupStyleSponsorColor.pinkoi(colorName)
            
            let markupStyleColor = MarkupStyleColor(sponsor: sponsor)?.getColor()
            XCTAssertNotNil(markupStyleColor)
            
            let comparison = MarkupStyleColor(red: colorName.rgb.0, green: colorName.rgb.1, blue: colorName.rgb.2, alpha: 1)?.getColor()
            XCTAssertTrue(markupStyleColor!.isEqual(comparison!))
        }
    }
    
    func testInitStyleFromVendorPinkoiColor() throws {
        let allCases = MarkupStyleVendorColor.PinkoiColor.allCases
        for colorName in allCases {
            let vendor = MarkupStyleVendorColor.pinkoi(colorName)
                        
            let markupStyleColor = MarkupStyleColor(vendor: vendor)?.getColor()
            XCTAssertNotNil(markupStyleColor)
            
            let comparison = MarkupStyleColor(red: colorName.rgb.0, green: colorName.rgb.1, blue: colorName.rgb.2, alpha: 1)?.getColor()
            XCTAssertTrue(markupStyleColor!.isEqual(comparison!))
        }
    }
    
    func testInitStyleFromColorName() throws {
        let allCases = MarkupStyleColorName.allCases
        for colorName in allCases {
            let markupStyleColor = MarkupStyleColor(name: colorName)?.getColor()
            XCTAssertNotNil(markupStyleColor)
            
            let comparison = MarkupStyleColor(red: colorName.rgb.0, green: colorName.rgb.1, blue: colorName.rgb.2, alpha: 1)?.getColor()
            XCTAssertTrue(markupStyleColor!.isEqual(comparison!))
        }
    }

    func testInitStyleFromColorHEXString() throws {
        // vaild hex string
        XCTAssertEqual(MarkupStyleColor(string: "#ff0099")?.getColor(), UIColor(red: 1.00, green: 0.00, blue: 0.60, alpha: 1.00))
        // vaild hex string with upper case
        XCTAssertEqual(MarkupStyleColor(string: "#FF0099")?.getColor(), UIColor(red: 1.00, green: 0.00, blue: 0.60, alpha: 1.00))

        // invaild hex string
        XCTAssertNil(MarkupStyleColor(string: "#HHGG99")?.getColor())
        // invaild hex string
        XCTAssertNil(MarkupStyleColor(string: "FF0099")?.getColor())
    }

    func testInitStyleFromColorRGBString() throws {
        // vaild rgb string: rbg(12, 30, 125)
        XCTAssertEqual(MarkupStyleColor(string: "rgb(15,30,60)")?.getColor(), UIColor(red: 15/255, green: 30/255, blue: 60/255, alpha: 1.00))
        
        // invaild rgb string: rbg(12, 30, 125)
        XCTAssertNil(MarkupStyleColor(string: "rgb(15,30,600)")?.getColor())
    }
    
    func testInitStyleFromColorRGBAString() throws {
        // vaild rgba string: rbg(12, 30, 125, 0.5)
        XCTAssertEqual(MarkupStyleColor(string: "rgba(15,30,60, 0.5)")?.getColor(), UIColor(red: 15/255, green: 30/255, blue: 60/255, alpha: 0.5))
        // invaild rgba string: rbg(12, 30, 125)
        XCTAssertNil(MarkupStyleColor(string: "rgb(15,30,60,2)")?.getColor())
    }
    
    func testInitStyleFromUINSColor() throws {
        XCTAssertEqual(MarkupStyleColor(color: .green).getColor(), UIColor.green)
    }

}
