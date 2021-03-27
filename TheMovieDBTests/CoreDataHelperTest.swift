//
//  CoreDataHelperTest.swift
//  TheMovieDBTests
//
//  Created by Jhonatan A. on 26/03/21.
//

import XCTest
@testable import TheMovieDB

class CoreDataHelperTest: XCTestCase {
    func testCoreDataHelper() {
        do {
            try CoreDataHelper.save()
        } catch {
            XCTFail()
        }
    }
}
