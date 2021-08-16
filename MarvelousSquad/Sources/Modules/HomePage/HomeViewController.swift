//
//  ViewController.swift
//  MarvelousSquad
//
//  Created by Quentin Eude on 11/08/2021.
//

import Backend
import Combine
import CoreData
import Nuke
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
        case initial, loading, data, error(error: Error)
    }

    private var state: State = .initial {
        didSet {
            switch state {
            case .loading:
                tableView.refreshControl?.beginRefreshing()
            default:
                tableView.refreshControl?.endRefreshing()
            }
        }
    }

    var superheroesFetchedResultsController: NSFetchedResultsController<Superhero>!
    private var currentOffset: Int = 0
    private var totalItems: Int = 0
    private var currentCount: Int = 0
    private var cancellables: Set<AnyCancellable> = []

    var insertIndexPaths = [IndexPath]()
    var deleteIndexPaths = [IndexPath]()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SuperheroCell.self, forCellReuseIdentifier: String(describing: SuperheroCell.self))
        tableView.backgroundColor = .systemBackground
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureFetchedResultsController()
        fetchSuperheroes(offset: 0)
    }

    @objc private func refresh(_: Any) {
        state = .loading
        let request: NSFetchRequest<Superhero> = Superhero.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let results = try storeProvider.persistentContainer.viewContext.fetch(request)
            for object in results {
                storeProvider.persistentContainer.viewContext.delete(object)
            }
        } catch {
            print("Detele all data in SuperHero error :", error)
        }
        fetchSuperheroes(offset: 0)
    }

    private func fetchSuperheroes(offset: Int) {
        storeProvider
            .listSuperheroes(with: offset)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case let .failure(error):
                    self.state = .error(error: error)
                }
            } receiveValue: { response in
                self.totalItems = response.total
                self.currentOffset = response.offset
                self.currentCount = self.currentOffset + response.count
                self.state = .data
            }
            .store(in: &cancellables)
    }

    private func updateNextSet() {
        if currentOffset != totalItems {
            fetchSuperheroes(offset: min(totalItems, currentOffset + 20))
        }
    }
}

// MARK: - UI Setup

extension HomeViewController {
    private func setupUI() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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

extension HomeViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let superhero = superheroesFetchedResultsController.fetchedObjects?[indexPath.row] else {
            return
        }
        let detailsVC = SuperheroDetailViewController(superhero: superhero)
        navigationController?.pushViewController(detailsVC, animated: true)
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == currentCount - 10 {
            updateNextSet()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return superheroesFetchedResultsController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SuperheroCell.self), for: indexPath) as? SuperheroCell else {
            return UITableViewCell()
        }
        let superhero = superheroesFetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = superhero.name
        Nuke.loadImage(with: superhero.thumbnailUrl, into: cell.avatarImageView)
        return cell
    }
}
