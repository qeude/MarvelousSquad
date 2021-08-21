//
//  HomeViewController+UITableView.swift
//  MarvelousSquad
//
//  Created by Quentin Eude on 21/08/2021.
//

import Foundation
import Nuke
import UIKit

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()

        let sectionLabel = UILabel(frame: CGRect(x: 16, y: 16, width:
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
        if indexPath.row == currentCount - 10 || indexPath.row == (superheroesFetchedResultsController.fetchedObjects?.count ?? -1) - 1 {
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

    private func updateNextSet() {
        if currentOffset != totalItems {
            fetchSuperheroes(offset: min(totalItems, currentOffset + paginationStep))
        }
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
