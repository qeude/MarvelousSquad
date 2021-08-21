//
//  SuperheroCell.swift
//  MarvelousSquad
//
//  Created by Quentin Eude on 12/08/2021.
//

import UIKit

class SuperheroCell: UITableViewCell {
    static let Identifier = String(describing: SuperheroCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        setupUI()
    }

    override func prepareForReuse() {
        titleLabel.text = ""
        avatarImageView.image = nil
    }

    private lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()

    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        let imageIcon = UIImage(systemName: "chevron.right")?.withTintColor(.tertiarySystemBackground, renderingMode: .alwaysOriginal)
        imageView.image = imageIcon
        return imageView
    }()
}

// MARK: - UI Setup

extension SuperheroCell {
    private func setupUI() {
        contentView.addSubview(mainView)

        mainView.addSubview(stackView)
        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(arrowImageView)

        let bottomConstraint = mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        bottomConstraint.priority = .required - 1
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            stackView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            bottomConstraint,
        ])
    }
}
