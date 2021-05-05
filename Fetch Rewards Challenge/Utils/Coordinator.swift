//
//  Coordinator.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 5/4/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    
}
