//
//  ViewModelTrackersCell.swift
//  Tracker
//
//  Created by Григорий Машук on 5.12.23.
//

import Foundation

final class ViewModelTrackersCell {
    @Observable<IndexPath> private(set) var indexPath: IndexPath
    @Observable<Result<Set<TrackerRecord>, Error>> private(set) var trackerRecord: Result<Set<TrackerRecord>, Error>
    
    private let trackerRecordStore: TrackerRecordStore
    
    convenience init
    
    init(indexPath: IndexPath, trackerRecord: Result<Set<TrackerRecord>, Error>, trackerRecordStore: TrackerRecordStore) {
        self.indexPath = indexPath
        self.trackerRecord = trackerRecord
        self.trackerRecordStore = trackerRecordStore
    }
}
