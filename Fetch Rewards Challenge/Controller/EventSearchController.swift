//
//  ViewController.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/9/20.
//

import UIKit

class EventSearchController: UITableViewController {
    
    // MARK: - Properties
    
    private var events = [Event]()
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        configureUI()
        configureSearchController()
        fetchEvents()
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
                self?.showLoader(false)
                print(error)
            }
        }
    }
    
    // MARK: - Actions
    
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

}

// MARK: - UITableViewDataSource

extension EventSearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as! EventCell
        cell.viewModel = EventCellViewModel(event: event)
        return cell
    }
}

// MARK: - UITableViewDeleagate

extension EventSearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let controller = EventDetailController()
        controller.event = event
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
