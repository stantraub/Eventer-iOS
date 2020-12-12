//
//  DatabaseManager.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/11/20.
//

import RealmSwift

class DatabaseManager {
    
    // MARK: - Properties
    
    static let shared = DatabaseManager()
    
    private let realm = try! Realm()
    
    // MARK: - Helpers
    
    func fetchFavoriteEvents() -> [FavoritedEvent] {
        return Array(realm.objects(FavoritedEvent.self))
    }
    
    func favoriteEvent(eventID: Int, completion: @escaping(Result<Bool, Error>) -> Void){
        let event = FavoritedEvent()
        event.eventId = eventID
        
        do {
            try realm.write {
                realm.add(event)
                completion(.success(true))
            }
        } catch {
            completion(.failure(DatabaseError.failedToFavoriteEvent(error: error)))
        }
    }
    
    
    func unfavoriteEvent(eventID: Int, completion: @escaping(Result<Bool, Error>) -> Void) {
        let event = realm.objects(FavoritedEvent.self).filter("eventId == \(eventID)")

        do {
            try realm.write {
                realm.delete(event)
                completion(.success(true))
            }
        } catch {
            completion(.failure(DatabaseError.failedToDeleteFavoriteEvent(error: error)))
        }
    }
    
    public enum DatabaseError: Error {
        case failedToFavoriteEvent(error: Error)
        case failedToDeleteFavoriteEvent(error: Error)
        
        public var localizedDescription: String {
            switch self {
            case .failedToFavoriteEvent(let error):
                return "Failed to save event as a favorite with: \(error)"
            case .failedToDeleteFavoriteEvent(let error):
                return "Faield to delete favorited event with: \(error)"
            }
        }
    }
}
