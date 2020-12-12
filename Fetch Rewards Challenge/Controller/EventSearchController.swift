//
//  ViewController.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/9/20.
//

import UIKit
import RealmSwift

class EventSearchController: UITableViewController {
    
    // MARK: - Properties
    
    let realm = try! Realm()
    
    private var events = [Event]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var favoritedEventIds = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        configureSearchController()
        fetchAndPopulateFavoritedEvents()
        fetchEvents()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        favoritedEventIds.removeAll()
        fetchAndPopulateFavoritedEvents()

        print(favoritedEventIds)
    }
    
    // MARK: - API
    
    private func fetchEvents() {
        showLoader(true)
        
        Service.fetchEvents { [weak self] result in
            switch result {
            case .success(let events):
                self?.events = events
                
                DispatchQueue.main.async {
                    self?.showLoader(false)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showLoader(false)
                }
                print(error)
            }
        }
    }
        
    // MARK: - Helpers
    
    private func configureUI() {
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        tableView.rowHeight = 180
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search events"
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
            textField.backgroundColor = .systemBlue
        }
    }
    
    private func fetchAndPopulateFavoritedEvents() {
        let favoritedEvents = realm.objects(FavoritedEvent.self)
        
        for event in favoritedEvents {
            favoritedEventIds.insert(event.eventId)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    private func addFavoriteEvent(eventID: Int) {
        let event = FavoritedEvent()
        event.eventId = eventID
        
        do {
            try realm.write { [weak self] in
                realm.add(event)
                favoritedEventIds.insert(eventID)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        } catch {
            print("Error saving event \(error)")
        }
    }
    
    private func unfavoriteEvent(eventID: Int) {
        let event = realm.objects(FavoritedEvent.self).filter("eventId == \(eventID)")
        
        do {
            try realm.write { [weak self] in
                realm.delete(event)
                favoritedEventIds.remove(eventID)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        } catch {
            print("Error deleting event \(error)")
        }
    }

}

// MARK: - UITableViewDataSource

extension EventSearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var event = events[indexPath.row]
        if favoritedEventIds.contains(event.id) {
            event.favorited = true
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as! EventCell
        cell.viewModel = EventViewModel(event: event)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDeleagate

extension EventSearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var event = events[indexPath.row]
        if favoritedEventIds.contains(event.id) {
            event.favorited = true
        }
        let controller = EventDetailController()
        controller.viewModel = EventViewModel(event: event)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension EventSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        print(searchText)
    }
}

extension EventSearchController: EventFavoritedProtocol {
    func didFavoriteEvent(eventID: Int) {
        if favoritedEventIds.contains(eventID) {
            unfavoriteEvent(eventID: eventID)
        } else {
            addFavoriteEvent(eventID: eventID)
        }
    }
}
