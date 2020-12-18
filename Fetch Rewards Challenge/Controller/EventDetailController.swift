//
//  EventDetailController.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/10/20.
//

import UIKit

final class EventDetailController: UIViewController {
    
    // MARK: - Properties
        
    var viewModel: EventViewModel? {
        didSet { configureWithViewModel() }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    private let eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        if #available(iOS 13.0, *) {
            let image = UIImage(named: "chevron.left")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
            button.setImage(image, for: .normal)
        } else {
            let image = UIImage(named: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            button.setImage(image, for: .normal)
        }
        
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleFavoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        if #available(iOS 13.0, *) {
            label.textColor = .secondaryLabel
        } else {
            label.textColor = .darkGray
        }
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        if #available(iOS 13.0, *) {
            label.textColor = .secondaryLabel
        } else {
            label.textColor = .darkGray
        }
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - Actions
    
    @objc private func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleFavoriteButtonTapped() {
        guard let viewModel = viewModel else { return }
        didFavoriteEvent(eventID: viewModel.id)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(eventImageView)
        eventImageView.anchor(top: view.topAnchor)
        eventImageView.setDimensions(height: view.frame.height / 3, width: view.frame.width)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 20)
        
        view.addSubview(favoriteButton)
        favoriteButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingRight: 20)
        
        configureGradientLayer()
        
        let stack = UIStackView(arrangedSubviews: [eventTitleLabel, dateLabel, locationLabel])
        stack.axis = .vertical
        stack.spacing = 8
        
        view.addSubview(stack)
        stack.anchor(top: eventImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 20)
    }
    
    private func configureWithViewModel() {
        guard let viewModel = viewModel else { return }
        eventImageView.sd_setImage(with: viewModel.image)
        eventTitleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
        locationLabel.text = viewModel.location
        favoriteButton.setImage(viewModel.favoriteButtonImageDetailController, for: .normal)
    }
    
    private func configureGradientLayer() {
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [-0.03, 0.05]
        gradientLayer.frame = view.frame
        view.layer.addSublayer(gradientLayer)
    }
}

// MARK: - EventFavoritedProtocol

extension EventDetailController: EventFavoritedProtocol {
    func didFavoriteEvent(eventID: Int) {
        guard var viewModel = viewModel else { return }
        
        if viewModel.isFavorited {
            DatabaseManager.shared.unfavoriteEvent(eventID: eventID) { [weak self] result in
                switch result {
                case .success(_):
                    viewModel.event.favorited.toggle()
                    DispatchQueue.main.async {
                        self?.favoriteButton.setImage(viewModel.favoriteButtonImageDetailController, for: .normal)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            DatabaseManager.shared.favoriteEvent(eventID: eventID) { [weak self] result in
                switch result {
                case .success(_):
                    viewModel.event.favorited.toggle()
                    DispatchQueue.main.async {
                        self?.favoriteButton.setImage(viewModel.favoriteButtonImageDetailController, for: .normal)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
