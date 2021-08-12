//
//  ViewController.swift
//  MarvelousSquad
//
//  Created by Quentin Eude on 11/08/2021.
//

import Backend
import Combine
import CoreData
import UIKit

class HomeViewController: UIViewController {
    init(storeProvider: StoreProviderProtocol) {
        self.storeProvider = storeProvider
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let storeProvider: StoreProviderProtocol

    private enum State {
        case initial, loading, data, noData, error(error: Error)
    }

    private var state: State = .initial {
        didSet {
            switch state {
            case .loading:
                collectionView.refreshControl?.beginRefreshing()
            default:
                collectionView.refreshControl?.endRefreshing()
                // Used this over reloadData to have a smoother reloading animation
                collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }

    var superheroesFetchedResultsController: NSFetchedResultsController<Superhero>!

    private var cancellables: Set<AnyCancellable> = []

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(SuperheroCell.self, forCellWithReuseIdentifier: String(describing: SuperheroCell.self))
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureFetchedResultsController()
        fetchSuperheroes()
    }

    @objc private func refresh(_: Any) {
        fetchSuperheroes()
    }

    private func fetchSuperheroes() {
        state = .loading

        storeProvider
            .listSuperheroes()
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case let .failure(error):
                    self.state = .error(error: error)
                }
            } receiveValue: { superheroes in
                if superheroes.isEmpty {
                    self.state = .noData
                } else {
                    self.state = .data
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UI Setup

extension HomeViewController {
    private func setupUI() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        navigationController?.view.backgroundColor = .systemBackground
    }

    private func collectionViewLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance:
            .plain)
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selectedItemAt: \(indexPath)")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return superheroesFetchedResultsController.fetchedObjects?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SuperheroCell.self), for: indexPath) as? SuperheroCell else {
            return UICollectionViewListCell()
        }
        let superhero = superheroesFetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = superhero.name
        return cell
    }
}
