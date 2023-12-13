//
//  Errors.swift
//  Tracker
//
//  Created by Григорий Машук on 16.11.23.
//

import Foundation
enum StoreErrors {
    enum TrackrerCategoryStoreError: Error {
        case decodingErrorInvalidNameCategori
        case getCategoryCoreDataError
    }
    
    enum TrackrerStoreError: Error {
        case getTrackerError
        case decodingErrorInvalidName
        case decodingErrorInvalidId
        case decodingErrorInvalidColor
        case decodingErrorInvalidEmoji
        case decodingErrorInvalidSchedul
    }
    
    enum NSSetError: Error {
        case transformationErrorInvalid
    }
    
    enum TrackrerRecordStoreError: Error {
        case decodingErrorInvalidId
        case decodingErrorInvalidDate
        case deleteError
        case loadTrackerRecord
        case getTrackerRecord
    }
    
    enum PinnedCategoryStoreError: Error {
        case decodingErrorInvalidName
    }
}
