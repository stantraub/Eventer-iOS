//
//  File.swift
//  Fetch Rewards Challenge
//
//  Created by Stanley Traub on 12/9/20.
//

import UIKit
import SDWebImage

class EventCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "EventCell"
    
    var viewModel: EventCellViewModel? {
        didSet { configure() }
    }
    
    private let eventImage: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(height: 90, width: 90)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 22
        iv.layer.cornerCurve = .continuous
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(eventImage)
        eventImage.anchor(top:topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 20)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, locationLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 8
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: eventImage.rightAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        eventImage.sd_setImage(with: viewModel.image)
        titleLabel.text = viewModel.title
        locationLabel.text = viewModel.location
        dateLabel.text = viewModel.date
    }
}
