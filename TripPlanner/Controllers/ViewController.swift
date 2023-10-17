//
//  ViewController.swift
//  TripPlanner
//
//  Created by user248619 on 10/16/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    lazy var myFetchResultController : NSFetchedResultsController<Stock> = {
        
        let fetch : NSFetchRequest<Stock> = Stock.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        
        let ftc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
         ftc.delegate = self
         
        return ftc
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        try? myFetchResultController.performFetch()
    }

   
        
}
extension ViewController : NSFetchedResultsControllerDelegate{
    
}

extension ViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate : NSPredicate? = nil
        if !searchText.isEmpty {
            predicate = NSPredicate(format: "name CONTAINS[c] %@ ", searchText)
        }
        //NSFetchedResultsController
        myFetchResultController.fetchRequest.predicate = predicate
        try? myFetchResultController.performFetch()
    }
}

