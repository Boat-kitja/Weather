//
//  MainVC.swift
//  Weather
//
//  Created by Kitja  on 17/10/2565 BE.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: ResultsViewController())
    let api = APIManger()
    var data = [CityName?]()
    
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
        fetchDataFromApi()
        fetchDataFromApi2()
        fetchDataFromApi3()
        fetchDataFromApi4()
        fetchDataFromApi5()
    }
    
    func fetchDataFromApi(){
        api.LatAndLon(cityName: "paris") { city in
            self.data.append(city)
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataFromApi2(){
        api.LatAndLon(cityName: "london") { city in
            self.data.append(city)
            DispatchQueue.main.async {
               
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataFromApi3(){
        api.LatAndLon(cityName: "bangkok") { city in
            self.data.append(city)
            DispatchQueue.main.async {
              
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataFromApi4(){
        api.LatAndLon(cityName: "tokyo") { city in
            self.data.append(city)
            DispatchQueue.main.async {
             
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataFromApi5(){
        api.LatAndLon(cityName: "hanoi") { city in
            self.data.append(city)
            DispatchQueue.main.async {
               
                self.tableView.reloadData()
            }
        }
    }
}

extension MainVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainVcCell", for: indexPath) as! MainVcCell
        if let data = data[indexPath.row] {
            cell.tempLabel.text = "\(Int((data.main.temp!.rounded(.down))))°"
            cell.nameLabel.text = data.name
            cell.codeLabel.text = data.weather[0].description!.capitalized
            cell.hTempLabel.text =  "H: \(Int((data.main.temp_max!.rounded(.down))))"
            cell.lTempLabel.text =  "L: \(Int((data.main.temp_min!.rounded(.down))))"

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        vc.passDataFromApiCall(name: data[indexPath.row]!.name)
        self.present(vc, animated: true
        )
    }
}

extension MainVC:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text!
        let vc = searchController.searchResultsController as? ResultsViewController
        vc?.filterArray(text: query)
    }
}
