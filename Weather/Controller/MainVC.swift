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
        cell.mainView.layer.cornerRadius = 15
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
        vc.currentPage = inDexForDetailViewToSwipe!
        vc.setupData = CityDataForMainView.shared.cirysData[indexPath.row]
        
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
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
//                let potato = CityDataForMainView.shared.cirysData[indexPath.row]
//                CityDataForMainView.shared.cirysData.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//
//                for i in CityDataForMainView.shared.cirysData.indices{
//                    if CityDataForMainView.shared.cirysData[i]!.index > potato!.index{
//                        CityDataForMainView.shared.cirysData[i]!.index = CityDataForMainView.shared.cirysData[i]!.index - 1
//                    }
//                }
//                complete(true)
//            }
//        deleteAction.backgroundColor = .red
//        deleteAction.image = UIImage(systemName: "trash")
//
//
//
//
//
//                let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//                configuration.performsFirstActionWithFullSwipe = true
//                return configuration
//    }
//
//        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//                let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, _ in
//
//                    CityDataForMainView.shared.cirysData.remove(at: indexPath.row)
//
//                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
//                }
//                deleteAction.backgroundColor = .red
//
//                return [deleteAction]
//            }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        var actions = [UIContextualAction]()

        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, view, completion) in

            let potato = CityDataForMainView.shared.cirysData[indexPath.row]
                            CityDataForMainView.shared.cirysData.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
                            for i in CityDataForMainView.shared.cirysData.indices{
                                if CityDataForMainView.shared.cirysData[i]!.index > potato!.index{
                                    CityDataForMainView.shared.cirysData[i]!.index = CityDataForMainView.shared.cirysData[i]!.index - 1
                                }
                            }
        

            completion(true)
        }

        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .bold, scale: .large)
        delete.image = UIImage(systemName: "trash", withConfiguration: largeConfig)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.systemRed)
        delete.backgroundColor = .systemBackground
        delete.title = "Delete"

        actions.append(delete)

        let config = UISwipeActionsConfiguration(actions: actions)
        config.performsFirstActionWithFullSwipe = false

        return config
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        CityDataForMainView.shared.cirysData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
  
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

extension UIImage {

    func addBackgroundCircle(_ color: UIColor?) -> UIImage? {

        let circleDiameter = max(size.width * 2, size.height * 2)
        let circleRadius = circleDiameter * 0.5
        let circleSize = CGSize(width: circleDiameter, height: circleDiameter)
        let circleFrame = CGRect(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
        let imageFrame = CGRect(x: circleRadius - (size.width * 0.5), y: circleRadius - (size.height * 0.5), width: size.width, height: size.height)

        let view = UIView(frame: circleFrame)
        view.backgroundColor = color ?? .systemRed
        view.layer.cornerRadius = circleDiameter * 0.5

        UIGraphicsBeginImageContextWithOptions(circleSize, false, UIScreen.main.scale)

        let renderer = UIGraphicsImageRenderer(size: circleSize)
        let circleImage = renderer.image { ctx in
            view.drawHierarchy(in: circleFrame, afterScreenUpdates: true)
        }

        circleImage.draw(in: circleFrame, blendMode: .normal, alpha: 1.0)
        draw(in: imageFrame, blendMode: .normal, alpha: 1.0)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
}
