//
//  EventSearchViewModel.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 5/4/21.
//

import Foundation

final class EventSearchViewModel {
    
    // MARK: - Properties
    
    typealias CompletionHandler = (Error?) -> Void
    
    var eventsCompletion: CompletionHandler?
    
    private(set) var events: [Event] = []
    
    // MARK: - Lifecycle
    
    func fetchEvents() {
        Service.fetchEvents { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let events):
                strongSelf.events = events
                strongSelf.eventsCompletion?(nil)
            case .failure(let error):
                strongSelf.eventsCompletion?(error)
            }
        }
    }
}
