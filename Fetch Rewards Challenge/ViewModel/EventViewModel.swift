//
//  EventCellViewModel.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/9/20.
//

import Foundation
import RealmSwift

struct EventViewModel {
    
    // MARK: - Properties
    
    private let event: Event
    private let realm = try! Realm()
    
    var id: Int {
        return event.id
    }
    
    var title: String {
        return event.title
    }
    
    var location: String {
        return event.venue.displayLocation
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = formatter.date(from: event.datetimeUtc)
        let formattedDisplayDate = DateFormatter()
        formattedDisplayDate.dateFormat = "EEEE, d MMM yyyy hh:mm a"
        
        guard let safeDate = date else { return "" }
        return formattedDisplayDate.string(from: safeDate)
    }
    
    var image: URL? {
        guard let image = event.performers.first?.image else { return URL(string: "")}
        return URL(string: image)
    }
    
    var favorited: Bool {
        return event.favorited
    }
    
    
    // MARK: - Lifecycle
    
    init(event: Event) {
        self.event = event

    }
}
