//
//  SuperheroDetailViewController.swift
//  MarvelousSquad
//
//  Created by Quentin Eude on 15/08/2021.
//

import Backend
import Nuke
import UI
import UIKit

class SuperheroDetailViewController: UIViewController {
    init(superhero: Superhero, storeProvider: StoreProviderProtocol) {
        self.storeProvider = storeProvider
        self.superhero = superhero
        squad = Squad.getSquad(with: storeProvider.persistentContainer)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isDirectionalLockEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var mainView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 32
        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()

    private lazy var titleLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.text = superhero.name
        return label
    }()

    private lazy var recruitButtonView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = false
        if squad.superheroes?.contains(superhero) == true {
            setFireStyle(button: button)
        } else {
            setRecruitStyle(button: button)
        }
        return button
    }()

    private lazy var descriptionLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = superhero.desc
        return label
    }()

    private let storeProvider: StoreProviderProtocol
    private let superhero: Superhero
    private let squad: Squad

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: Setup UI

extension SuperheroDetailViewController {
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        mainView.addSubview(mainStackView)

        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(contentStackView)

        contentStackView.addArrangedSubview(titleLabelView)
        contentStackView.addArrangedSubview(recruitButtonView)
        contentStackView.addArrangedSubview(descriptionLabelView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 450),
            imageView.leftAnchor.constraint(equalTo: mainStackView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: mainStackView.rightAnchor),
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            mainView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            mainStackView.topAnchor.constraint(equalTo: mainView.topAnchor),
            mainStackView.rightAnchor.constraint(equalTo: mainView.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            mainStackView.leftAnchor.constraint(equalTo: mainView.leftAnchor),
            contentStackView.leftAnchor.constraint(equalTo: mainStackView.leftAnchor, constant: 16),
            contentStackView.rightAnchor.constraint(equalTo: mainStackView.rightAnchor, constant: -16),
            recruitButtonView.heightAnchor.constraint(equalToConstant: 55),
        ])

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.setClear()
        Nuke.loadImage(with: superhero.thumbnailUrl, into: imageView)
    }

    private func setRecruitStyle(button: UIButton) {
        button.backgroundColor = .red
        button.setTitle("💪 Recruit to squad", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.shadowColor = UIColor.red.cgColor
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.9
        button.layer.shadowOffset = .zero
        button.removeTarget(nil, action: nil, for: .allEvents)
        button.addTarget(nil, action: #selector(recruit(_:)), for: .touchUpInside)
    }

    @objc private func recruit(_: UIButton) {
        squad.addToSuperheroes(superhero)
        storeProvider.persistentContainer.saveContext()
        setFireStyle(button: recruitButtonView)
    }

    private func setFireStyle(button: UIButton) {
        button.backgroundColor = .clear
        button.setTitle("🔥 Fire from squad", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.shadowColor = nil
        button.layer.shadowRadius = 0
        button.layer.shadowOpacity = 0
        button.layer.shadowOffset = .zero
        button.removeTarget(nil, action: nil, for: .allEvents)
        button.addTarget(nil, action: #selector(fire(_:)), for: .touchUpInside)
    }

    @objc private func fire(_: UIButton) {
        squad.removeFromSuperheroes(superhero)
        storeProvider.persistentContainer.saveContext()
        setRecruitStyle(button: recruitButtonView)
    }
}

extension SuperheroDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= imageView.frame.maxY, navigationController?.navigationBar.shadowImage != nil {
            navigationController?.setDefault()
        } else if navigationController?.navigationBar.shadowImage == nil {
            navigationController?.setClear()
        }
    }
}
