//
//  EventFields.swift
//  Tracker
//
//  Created by Григорий Машук on 24.12.23.
//

import Foundation
enum EventFields: String {
    case event
    case screen
    case item
}

enum Event: String {
    case open
    case close
    case click
}

enum Screen: String {
    case Main
}

enum ItemClick: String {
    case add_track
    case track
    case filter
    case edit
    case delete
}

