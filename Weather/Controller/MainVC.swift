//
//  MainVC.swift
//  Weather
//
//  Created by Kitja  on 17/10/2565 BE.
//

import UIKit

class MainVC: UIViewController{
   
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: ResultsViewController())
    let api = APIManger()
//    var data = [CityName?]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.textColor = .white
        searchController.dimsBackgroundDuringPresentation = true
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white], for: .normal)

        title = "Weather"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MainVcCell", bundle: nil), forCellReuseIdentifier: "MainVcCell")
    }
    
    @IBAction func editTableView() {
     
        if tableView.isEditing{
            tableView.isEditing = false
        }else{
            tableView.isEditing = true
        }
    }
}

extension MainVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CityDataForMainView.shared.cirysData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainVcCell", for: indexPath) as! MainVcCell
//        
//        cell.contentView.superview?.backgroundColor = .black
//        cell.contentView.superview?.
        if let
            data = CityDataForMainView.shared.cirysData[indexPath.row]{
            
            cell.tempLabel.text = "\(Int(((data.firstSection?.main.temp!.rounded(.down))!)))°"
            cell.nameLabel.text = data.firstSection?.name
            cell.codeLabel.text = data.firstSection!.weather[0].description!.capitalized
            cell.hTempLabel.text =  "H: \(Int((data.firstSection! .main.temp_max!.rounded(.down))))"
            cell.lTempLabel.text =  "L: \(Int((data.firstSection!.main.temp_min!.rounded(.down))))"

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SuperMainVC") as! SuperMainVC
        let test = CityDataForMainView.shared.cirysData[indexPath.row]?.firstSection?.name
        let inDexForDetailViewToSwipe = CityDataForMainView.shared.cirysData.firstIndex(where: {$0?.firstSection?.name == test })
        vc.indexForAllWeatherData = inDexForDetailViewToSwipe
        
//        print("what i want\(vc.indexForAllWeatherData)")
//        
        print("what i want\(inDexForDetailViewToSwipe)")
        vc.modalPresentationStyle = .fullScreen 
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
                let potato = CityDataForMainView.shared.cirysData[indexPath.row]
                CityDataForMainView.shared.cirysData.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                for i in CityDataForMainView.shared.cirysData.indices{
                    if CityDataForMainView.shared.cirysData[i]!.index > potato!.index{
                        CityDataForMainView.shared.cirysData[i]!.index = CityDataForMainView.shared.cirysData[i]!.index - 1
                    }
                }
                complete(true)
            }
        deleteAction.backgroundColor = .red
        
        
                
                let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
                configuration.performsFirstActionWithFullSwipe = true
                return configuration
    }
        
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
                let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, _ in

                    CityDataForMainView.shared.cirysData.remove(at: indexPath.row)

                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                deleteAction.backgroundColor = .red

                return [deleteAction]
            }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        CityDataForMainView.shared.cirysData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
//    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.backgroundColor = .red
//    }
}

extension MainVC:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text!
        let vc = searchController.searchResultsController as? ResultsViewController
        vc?.delegate = self
        vc?.filterArray(text: query)
    }
}

extension MainVC:RefreshDataMainDelegate{
    func refreshDataMain() {
        tableView.reloadData()
    }
    
   
    
    
}
