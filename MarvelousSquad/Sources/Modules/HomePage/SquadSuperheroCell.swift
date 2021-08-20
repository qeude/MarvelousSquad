//
//  SquadSuperheroCell.swift
//  MarvelousSquad
//
//  Created by Quentin Eude on 17/08/2021.
//

import UIKit

class SquadSuperheroCell: UICollectionViewCell {
    static let Identifier = String(describing: SquadSuperheroCell.self)
    override func layoutSubviews() {
        setupUI()
    }

    override func prepareForReuse() {
        titleLabel.text = ""
        avatarImageView.image = nil
    }

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()

    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
}

extension SquadSuperheroCell {
    private func setupUI() {
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
        ])
    }
}
