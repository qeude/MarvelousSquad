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
    private var squad: Squad
    private var currentOffset: Int = 0
    private var totalItems: Int = 0
    private var currentCount: Int = 0
    private var cancellables: Set<AnyCancellable> = []

    var insertIndexPaths = [IndexPath]()
    var deleteIndexPaths = [IndexPath]()

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
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
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

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let titleImageView = UIImageView(image: UIImage(named: "marvel-logo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height - 5)
        titleImageView.contentMode = .scaleAspectFit
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()

        let sectionLabel = UILabel(frame: CGRect(x: 16, y: 28, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 22)
        sectionLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.numberOfSections > 1, section == 0 {
            return 50
        }
        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.numberOfSections > 1, section == 0 {
            return "My Squad"
        }
        return nil
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.numberOfSections == 1 {
            guard let superhero = superheroesFetchedResultsController.fetchedObjects?[indexPath.row] else {
                return
            }
            let detailsVC = SuperheroDetailViewController(superhero: superhero, storeProvider: storeProvider)
            navigationController?.pushViewController(detailsVC, animated: true)
        }
        switch indexPath.section {
        case 0:
            break
        case 1:
            guard let superhero = superheroesFetchedResultsController.fetchedObjects?[indexPath.row] else {
                return
            }
            let detailsVC = SuperheroDetailViewController(superhero: superhero, storeProvider: storeProvider)
            navigationController?.pushViewController(detailsVC, animated: true)
        default:
            break
        }
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == currentCount - 10 {
            updateNextSet()
        }

        guard let cell = cell as? SquadCell else { return }

        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }

    func numberOfSections(in _: UITableView) -> Int {
        if squad.superheroes?.count == 0 {
            return 1
        }
        return 2
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.numberOfSections == 1 {
            return superheroesFetchedResultsController.fetchedObjects?.count ?? 0
        }
        switch section {
        case 0:
            return 1
        case 1:
            return superheroesFetchedResultsController.fetchedObjects?.count ?? 0
        default:
            fatalError("section not implemented")
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.numberOfSections == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SuperheroCell.Identifier, for: indexPath) as? SuperheroCell else {
                return UITableViewCell()
            }
            let superhero = superheroesFetchedResultsController.object(at: indexPath)
            cell.titleLabel.text = superhero.name
            Nuke.loadImage(with: superhero.thumbnailUrl, into: cell.avatarImageView)
            return cell
        }

        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SquadCell.Identifier, for: indexPath) as? SquadCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SuperheroCell.Identifier, for: indexPath) as? SuperheroCell else {
                return UITableViewCell()
            }
            let superhero = superheroesFetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0))
            cell.titleLabel.text = superhero.name
            Nuke.loadImage(with: superhero.thumbnailUrl, into: cell.avatarImageView)
            return cell
        default:
            fatalError("section not implemented")
        }
    }
}
