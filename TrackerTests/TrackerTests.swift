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
    let vc = TrackersViewController(viewModel: TrackerViewModel())
    
    func testTrackersViewControllerDark() {
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .dark)),
                       record: false)
    }
    
    func testTrackersViewControllerLight() {
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)),
                       record: false)
    }
}
