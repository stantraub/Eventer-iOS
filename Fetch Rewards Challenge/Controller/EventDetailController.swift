//
//  EventDetailController.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/10/20.
//

import UIKit

class EventDetailController: UIViewController {
    
    // MARK: - Properties
    
    var event: Event? {
        didSet { configure() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    private func configure() {
        guard let event = event else { return }
        print(event)
    }
}
