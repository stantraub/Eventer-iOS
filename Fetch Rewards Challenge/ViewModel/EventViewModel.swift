//
//  EventCellViewModel.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/9/20.
//

import Foundation

struct EventViewModel {
    
    // MARK: - Properties
    
    private let event: Event
    
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
    
    // MARK: - Lifecycle
    
    init(event: Event) {
        self.event = event
    }
}
