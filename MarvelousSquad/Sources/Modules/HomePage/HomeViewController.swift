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
    let paginationStep = 20

    init(storeProvider: StoreProviderProtocol) {
        self.storeProvider = storeProvider
        squad = Squad.getSquad(with: storeProvider.persistentContainer)
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
    var squad: Squad
    var totalItems: Int = 0
    var currentCount: Int = 0
    private var cancellables: Set<AnyCancellable> = []

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SuperheroCell.self, forCellReuseIdentifier: SuperheroCell.Identifier)
        tableView.register(SquadCell.self, forCellReuseIdentifier: SquadCell.Identifier)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setDefault()
    }

    @objc private func refresh(_: Any) {
        state = .loading
        fetchSuperheroes(offset: 0)
    }

    func fetchSuperheroes(offset: Int) {
        currentCount = currentCount + paginationStep
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
                self.state = .data
            }
            .store(in: &cancellables)
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

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let titleImageView = UIImageView(image: UIImage(named: "marvel-logo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height - 5)
        titleImageView.contentMode = .scaleAspectFit
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
        let arrowImage = UIImage(systemName: "arrow.left")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .bold))
        navigationController?.navigationBar.backIndicatorImage = arrowImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = arrowImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
