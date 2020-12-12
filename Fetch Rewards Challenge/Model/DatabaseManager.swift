//
//  DatabaseManager.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/11/20.
//

//import RealmSwift
//
//class DatabaseManager {
//
//    // MARK: - Properties
//
//    static let shared = DatabaseManager()
//
//    private let realm = try! Realm()
//
//    // MARK: - Helpers
//
//    func favoriteEvent(eventID: Int) {
//        let event = FavoritedEvent()
//        event.eventId = eventID
//
//        do {
//            try realm.write {
//                realm.add(event)
//            }
//        } catch {
//            print("Error saving event \(error)")
//        }
//    }
//
//
//    func unfavoriteEvent(eventID: Int) {
//        let event = realm.objects(FavoritedEvent.self).filter("eventId == \(eventID)")
//
//        do {
//            try realm.write { [weak self] in
//                realm.delete(event)
//                favoritedEventIds.remove(eventID)
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            }
//        } catch {
//            print("Error deleting event \(error)")
//        }
//    }
//}
