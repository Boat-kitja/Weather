//
//  ResultsViewController.swift
//  Weather
//
//  Created by Kitja  on 21/10/2565 BE.
//

import UIKit

protocol RefreshDataMainDelegate {
  func refreshDataMain()
}

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView:UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let places = Country()
    var search = [String]()
    var delegate:RefreshDataMainDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        view.backgroundColor = .black
        tableView.backgroundColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        
     
        tableView.frame = view.bounds
//        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
        
    
        
    }
    
    func filterArray(text:String){
        search = []
        
        for i in places.countryList {
            if i.lowercased().contains(text.lowercased()){
                search.append(i)
//                print(search)
            }
        }
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = search[indexPath.row]
        cell.contentView.backgroundColor = UIColor.black
        cell.textLabel?.textColor = .white
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailVCFromSeatch") as! DetailVCFromSearch
        vc.delegate = self
        vc.passDataFromApiCall(name: search[indexPath.row])
       
        present(vc, animated: true, completion: nil)
      
       
//            self.present(vc, animated: true)
        
    }
}

extension ResultsViewController:RefreshDataDelegate{
    func refreshData() {
        delegate?.refreshDataMain()
    }
    
}
    

