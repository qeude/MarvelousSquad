//
//  HomeViewController+UICollectionView.swift
//  MarvelousSquad
//
//  Created by Quentin Eude on 18/08/2021.
//

import Foundation
import Nuke
import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return superheroesFetchedResultsController.fetchedObjects?.compactMap {
            return $0.squad != nil ? $0 : nil
        }.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquadSuperheroCell.Identifier, for: indexPath) as? SquadSuperheroCell else {
            return UICollectionViewCell()
        }
        let items = superheroesFetchedResultsController.fetchedObjects?.compactMap {
            return $0.squad != nil ? $0 : nil
        }
        let superhero = items?[indexPath.row]
        cell.titleLabel.text = superhero?.name ?? ""
        Nuke.loadImage(with: superhero?.thumbnailUrl, into: cell.avatarImageView)
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let items = superheroesFetchedResultsController.fetchedObjects?.compactMap {
            return $0.squad != nil ? $0 : nil
        }
        guard let superhero = items?[indexPath.row] else {
            return
        }
        let detailsVC = SuperheroDetailViewController(superhero: superhero, storeProvider: storeProvider)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
