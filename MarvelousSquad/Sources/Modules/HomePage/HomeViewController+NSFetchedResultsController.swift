//
//  HomePageViewController+NSFetchedResultsController.swift
//  MarvelousSquad
//
//  Created by Quentin Eude on 12/08/2021.
//

import Backend
import CoreData
import Foundation

extension HomeViewController: NSFetchedResultsControllerDelegate {
    func configureFetchedResultsController() {
        let request: NSFetchRequest<Superhero> = Superhero.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]

        superheroesFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: storeProvider.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        superheroesFetchedResultsController.delegate = self

        do {
            try superheroesFetchedResultsController.performFetch()
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        } catch {
            print("Fetch failed")
        }
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at _: IndexPath?, for _: NSFetchedResultsChangeType, newIndexPath _: IndexPath?) {
        tableView.reloadData()
    }
}
