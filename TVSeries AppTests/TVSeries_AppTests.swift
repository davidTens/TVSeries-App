//
//  TVSeries_AppTests.swift
//  TVSeries AppTests
//
//  Created by David T on 3/29/21.
//

import XCTest

class TVSeries_AppTests: XCTestCase {
    func testDetailStrings() {
        
        let detailVC = SerieDetailVC()
        let testArray = ["Overview", "Name", "First Air", "Countries", "Language"]
        
        XCTAssertEqual(detailVC.descriptionData, testArray)
        XCTAssertEqual(detailVC.noImageLabel.text, "No image")
        
    }

}
