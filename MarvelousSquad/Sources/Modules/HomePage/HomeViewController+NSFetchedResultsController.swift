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

    func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        insertIndexPaths = [IndexPath]()
        deleteIndexPaths = [IndexPath]()
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at _: IndexPath?, for _: NSFetchedResultsChangeType, newIndexPath _: IndexPath?) {
        tableView.reloadData()
        //        switch type {
//        case .insert:
//            guard let indexPath = newIndexPath else {
//                return
//            }
//            insertIndexPaths.append(indexPath)
//        case .delete:
//            guard let indexPath = indexPath else {
//                return
//            }
//            deleteIndexPaths.append(indexPath)
//        case .move, .update:
//            break
//        @unknown default:
//            fatalError("Unhandled type: \(type)")
//        }
    }

//    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.performBatchUpdates({
//            for indexPath in self.insertIndexPaths {
//                self.tableView.insertRows(at: [indexPath], with: .automatic)
//            }
//
//            for indexPath in self.deleteIndexPaths {
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            }
//        }, completion: { _ in
//        })
//    }
}
