//
//  ViewController.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/9/20.
//

import UIKit

final class EventSearchController: UITableViewController {
    
    // MARK: - Properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var events = [Event]()
    private var filteredEvents = [Event]()
    private var favoritedEventIds = Set<Int>()
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        fetchAndPopulateFavoritedEvents()
        fetchEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: "Events")
        favoritedEventIds.removeAll()
        fetchAndPopulateFavoritedEvents()
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
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = .systemBackground
        } else {
            tableView.backgroundColor = .white
        }
        
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        tableView.rowHeight = 180
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search events"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController

        definesPresentationContext = false
    }
    
    private func fetchAndPopulateFavoritedEvents() {
        let favoritedEvents = DatabaseManager.shared.fetchFavoriteEvents()
        
        for event in favoritedEvents {
            favoritedEventIds.insert(event.eventId)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension EventSearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredEvents.count : events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var event = inSearchMode ? filteredEvents[indexPath.row] : events[indexPath.row]
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
        var event = inSearchMode ? filteredEvents[indexPath.row] : events[indexPath.row]
        if favoritedEventIds.contains(event.id) {
            event.favorited = true
        }
        let controller = EventDetailController()
        controller.viewModel = EventViewModel(event: event)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension EventSearchController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = nil
    }
}

// MARK: - UISearchResultsUpdating

extension EventSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredEvents = events.filter { $0.title.lowercased().contains(searchText) }
        print(filteredEvents)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension EventSearchController: EventFavoritedProtocol {
    func didFavoriteEvent(eventID: Int) {
        if favoritedEventIds.contains(eventID) {
            DatabaseManager.shared.unfavoriteEvent(eventID: eventID) { [weak self] result in
                switch result {
                case .success(_):
                    self?.favoritedEventIds.remove(eventID)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            DatabaseManager.shared.favoriteEvent(eventID: eventID) { [weak self] result in
                switch result {
                case .success(_):
                    self?.favoritedEventIds.insert(eventID)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
