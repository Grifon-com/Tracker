//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Григорий Машук on 21.12.23.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testViewController() {
        let vc = TabBarController()
        assertSnapshot(matching: vc, as: .image)
    }
}
