//
//  Errors.swift
//  Tracker
//
//  Created by Григорий Машук on 16.11.23.
//

import Foundation
enum StoreErrors {
    enum TrackrerCategoryStoreError: Error {
        case decodingErrorInvalidNameCategory
        case getCategoryCoreDataError
        
        var localizedDescription: String {
            var localizedDescription = ""
            switch self {
            case .decodingErrorInvalidNameCategory:
                localizedDescription = NSLocalizedString("decodingErrorInvalidNameCategory", comment: "")
            case .getCategoryCoreDataError:
                localizedDescription = NSLocalizedString("getCategoryCoreDataError", comment: "")
            }
            return localizedDescription
        }
    }
    
    enum TrackrerStoreError: Error {
        case getTrackerError
        case decodingErrorInvalidName
        case decodingErrorInvalidId
        case decodingErrorInvalidColor
        case decodingErrorInvalidEmoji
        case decodingErrorInvalidSchedul
        
        var localizedDescription: String {
            var localizedDescription = ""
            switch self {
            case .getTrackerError:
                localizedDescription = NSLocalizedString("getTrackerError", comment: "")
            case .decodingErrorInvalidName:
                localizedDescription = NSLocalizedString("decodingErrorInvalidName", comment: "")
            case .decodingErrorInvalidId:
                localizedDescription = NSLocalizedString("decodingErrorInvalidId", comment: "")
            case .decodingErrorInvalidColor:
                localizedDescription = NSLocalizedString("decodingErrorInvalidColor", comment: "")
            case .decodingErrorInvalidEmoji:
                localizedDescription = NSLocalizedString("decodingErrorInvalidEmoji", comment: "")
            case .decodingErrorInvalidSchedul:
                localizedDescription = NSLocalizedString("decodingErrorInvalidSchedul", comment: "")
            }
            
            return localizedDescription
        }
    }
    
    enum NSSetError: Error {
        case transformationErrorInvalid
        
        var localizedDescription: String {
            NSLocalizedString("transformationErrorInvalid", comment: "")
        }
    }
    
    enum TrackrerRecordStoreError: String, Error {
        case decodingErrorInvalidId
        case decodingErrorInvalidDate
        case loadTrackerRecord
        case getTrackerRecord
        
        var localizedDescription: String {
            var localizedDescription = ""
            switch self {
            case .decodingErrorInvalidId:
                localizedDescription = NSLocalizedString(self.rawValue, comment: "")
            case .decodingErrorInvalidDate:
                localizedDescription = NSLocalizedString(self.rawValue, comment: "")
            case .loadTrackerRecord:
                localizedDescription = NSLocalizedString(self.rawValue, comment: "")
            case .getTrackerRecord:
                localizedDescription = NSLocalizedString(self.rawValue, comment: "")
            }
            
            return localizedDescription
        }
    }
}
