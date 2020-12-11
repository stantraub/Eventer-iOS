//
//  Event.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/9/20.
//

import Foundation

struct Event: Codable {
    let id: Int
    let title: String
    let datetimeUtc: String
    let venue: Venue
    let performers: [Performer]
    var favorited: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case datetimeUtc = "datetime_utc"
        case venue = "venue"
        case performers = "performers"
    }
}

struct Performer: Codable {
    let image: String?
}

struct Venue: Codable {
    let displayLocation: String
    
    enum CodingKeys: String, CodingKey {
        case displayLocation = "display_location"
    }
}
