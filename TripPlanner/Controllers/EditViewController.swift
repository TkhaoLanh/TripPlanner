//
//  EditViewController.swift
//  TripPlanner
//
//  Created by user248619 on 10/16/23.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    
    lazy var resultsTableController =
    self.storyboard?.instantiateViewController(withIdentifier: "Search") as? SearchStocksTableViewController
    
    
    lazy var searchconroller = UISearchController(searchResultsController: resultsTableController)
    
    var thisStock : Stock? = nil {
        didSet{
            
            
        }
    }
    
    
    init?(coder: NSCoder, stock : Stock) {
        super.init(coder: coder)
        thisStock = stock
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchconroller
        searchconroller.searchResultsUpdater = self
        resultsTableController?.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
  //  var stockNames : [String] = []
    
    func getData() {
        let searchText = searchconroller.searchBar.text ?? ""
        let url = "https://ms-finance.p.rapidapi.com/market/v2/auto-complete"
        
        let query = ["q" : searchText]
        Service.shared.getData(url: url, query: query) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                do {
                    let sData = try JSONDecoder().decode(stockReuslts.self, from: data)
                    let filtered = sData.results?.filter({ $0.name.range(of: searchText, options: .caseInsensitive) != nil })
                    if let filteredStock = filtered {
                        let stockNames = filteredStock.compactMap { $0.name } // Unwrap optional strings
                        self.resultsTableController?.StockList = stockNames
                        DispatchQueue.main.async {
                            self.resultsTableController?.tableView.reloadData()
                            // You don't need to assign self.stockNames again; it's already assigned to stockNames
                        }
                    }
                } catch {
                    print(error) // Handle the decoding error here
                }
            }
        }
    }

}

extension EditViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        getData()
    }
    
    
}

extension EditViewController : didfinishSearchDelegate{
    func didFinishSearchWith(stockName: String?) {
        searchconroller.isActive = false
        title = stockName
        if thisStock == nil{
        thisStock = Stock(context: CoreDataStack.shared.persistentContainer.viewContext)
            
        }

    }
}
