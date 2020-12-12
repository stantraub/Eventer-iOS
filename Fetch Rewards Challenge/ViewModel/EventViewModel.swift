//
//  EventCellViewModel.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/9/20.
//

import UIKit

class EventViewModel {
    
    // MARK: - Properties
    
    var event: Event
    
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
    
    var isFavorited: Bool {
        return event.favorited
    }
    
    var favoriteButtonImageEventCell: UIImage? {
        if isFavorited {
            if #available(iOS 13.0, *) {
                return UIImage(named: "suit.heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
            } else {
                return UIImage(named: "suit.heart.fill")?.withRenderingMode(.alwaysOriginal)
            }
        } else {
            if #available(iOS 13.0, *) {
                return UIImage(named: "suit.heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.label)
            } else {
                return UIImage(named: "suit.heart")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    var favoriteButtonImageDetailController: UIImage? {
        if isFavorited {
            if #available(iOS 13.0, *) {
                return UIImage(named: "suit.heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
            } else {
                return UIImage(named: "suit.heart.fill")?.withRenderingMode(.alwaysOriginal)
            }
        } else {
            if #available(iOS 13.0, *) {
                return UIImage(named: "suit.heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
            } else {
                return UIImage(named: "suit.heart")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    init(event: Event) {
        self.event = event
    }
}
