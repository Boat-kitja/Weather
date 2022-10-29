//
//  SuperCell.swift
//  Weather
//
//  Created by Kitja  on 27/10/2565 BE.
//

import UIKit

class SuperCell: UICollectionViewCell,UITableViewDataSource{
   
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!

    @IBOutlet weak var   codeLabel: UILabel!
    @IBOutlet weak var hTempLabel: UILabel!
    @IBOutlet weak var lTempLabel: UILabel!
//
//    @IBOutlet weak var firstTableView: UITableView!
//    @IBOutlet weak var dayTableView: UITableView!
//    @IBOutlet weak var airTableView: UITableView!
//    @IBOutlet weak var lastCollectioView: UICollectionView!
//
    @IBOutlet weak var tableView: UITableView!
    var setupData:AllWeatherData?
    
    var day = Calendar.current.component(.weekday, from: Date())
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        _ = dateFormatter.string(from: date)
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DetailVcCell", bundle: nil), forCellReuseIdentifier: "DetailVcCell")
        
//        lastCollectioView.dataSource = self
//        lastCollectioView.delegate = self
//        lastCollectioView.layer.cornerRadius = 15
////        lastCollectioView.backgroundColor = mainView.backgroundColor
//        lastCollectioView.register(UINib(nibName: "LastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LastCollectionViewCell")
//
//
//        dayTableView.dataSource = self
//        dayTableView.delegate = self
//        dayTableView.register((UINib(nibName: "DetailVcCell", bundle: nil)), forCellReuseIdentifier: "DetailVcCell")
//        dayTableView.layer.cornerRadius = 15
//
//        airTableView.dataSource = self
//        airTableView.delegate = self
//        airTableView.register((UINib(nibName: "DetailAirVcCell", bundle: nil)), forCellReuseIdentifier: "DetailAirVcCell")
//        airTableView.layer.cornerRadius = 15
//
//
//        firstTableView.delegate = self
//        firstTableView.register(FirstTableViewCell.nib(), forCellReuseIdentifier: FirstTableViewCell.identifier)
//        firstTableView.layer.cornerRadius = 15
        
        
//
        
        allreloadData()
    }
    
    func setupFirstSection() {
        if let setupData = setupData?.firstSection {
            nameLabel.text = setupData.name
            tempLabel.text = "\(Int(((setupData.main.temp?.rounded(.down))!)))°"
            codeLabel.text = setupData.weather[0].description?.capitalized
            hTempLabel.text = "H:\(Int(((setupData.main.temp_max?.rounded(.down))!)))°"
            lTempLabel.text = "L:\(Int(((setupData.main.temp_min?.rounded(.down))!)))°"
        }
    }
   
    
    func allreloadData(){
        setupFirstSection()
        tableView.reloadData()
//
//        lastCollectioView.reloadData()
//        firstTableView.reloadData()
//        airTableView.reloadData()
//        lastCollectioView.reloadData()
//        dayTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setupData?.dayForecast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailVcCell") as! DetailVcCell
        cell.daysLabel.text = "HI"
        
        return cell
    }
    

}

//extension SuperCell:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == dayTableView{
//            return setupData?.dayForecast?.count ?? 0
//        }else if tableView == airTableView{
//            return setupData?.airQuility.count ?? 0
//        }else if tableView == firstTableView{
//            return 1
//        }
//        return Int()
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        if tableView == dayTableView{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailVcCell", for: indexPath) as! DetailVcCell
//            switch day {
//            case 1 :
//                cell.daysLabel.text = SevenDay.sharedInstance.day1[indexPath.row]
//            case 2 :
//                cell.daysLabel.text = SevenDay.sharedInstance.day2[indexPath.row]
//            case 3 :
//                cell.daysLabel.text = SevenDay.sharedInstance.day3[indexPath.row]
//            case 4 :
//                cell.daysLabel.text = SevenDay.sharedInstance.day4[indexPath.row]
//            case 5 :
//                cell.daysLabel.text = SevenDay.sharedInstance.day5[indexPath.row]
//            case 6 :
//                cell.daysLabel.text = SevenDay.sharedInstance.day6[indexPath.row]
//            case 7 :
//                cell.daysLabel.text = SevenDay.sharedInstance.day7[indexPath.row]
//            default :
//                cell.daysLabel.text = "non"
//            }
//
//            if let setCell = setupData?.dayForecast?[indexPath.row].weather[0].conditionName{
//                cell.codeImage.image = UIImage(systemName: setCell)
//            }
//
//            cell.htempLabel.text = "H:\(Int((setupData?.dayForecast?[indexPath.row].main.temp_max?.rounded(.down))!) )°"
//            cell.ltempLabel.text = "L:\(Int((setupData?.dayForecast?[indexPath.row].main.temp_min?.rounded(.down))!) )°"
//
//            return cell
            
//        } else if
//            tableView == airTableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailAirVcCell", for: indexPath) as! DetailAirVcCell
//            if let airData = setupData?.airQuility {
//                if airData[0] != nil {
//                    cell.airLabel.text = "\(airData[0]!)"
//                    cell.meter.value = CGFloat(Float(airData[0]!)/100)
//                    if airData[0]! < 50 {
//                        cell.airStatusLabel.text = "GOOD"
//                        cell.airDetailLabel.text = "Air quality is satisfactory, and air pollution poses little or no risk."
//                    }else if airData[0]! < 99 {
//                        cell.airStatusLabel.text = "SATTISFACTORY"
//                        cell.airDetailLabel.text = "Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution."
//                    }else {
//                        cell.airStatusLabel.text = "POOR"
//                        cell.airDetailLabel.text = "Members of sensitive groups may experience health effects. The general public is less likely to be affected."
//                    }
//                }else {
//                    cell.airLabel.text = "ERROR"
//                    cell.airStatusLabel.text = "ERROR"
//                }
//            }
//            return cell
//
//        }else if
//            tableView == firstTableView{
//            let cell = tableView.dequeueReusableCell(withIdentifier: FirstTableViewCell.identifier, for: indexPath) as! FirstTableViewCell
//            if let setcell = setupData?.hourlyForecast{
//                cell.test = setcell
//                cell.collectionView.reloadData()
//            }
//            return cell
//        }
//        return UITableViewCell()
//    }
    
    
//
    
    
//}

//extension SuperCell:UICollectionViewDelegate,UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return setupData?.other.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastCollectionViewCell", for: indexPath) as! LastCollectionViewCell
//
//        if let setCell = setupData?.other[indexPath.row]{
//            cell.headerLabel.text = setCell.header
//            cell.mainLabel.text = setCell.main
//            cell.detailLabel.text = setCell.deta
//            cell.view.layer.cornerRadius = 15
//        }
//        return cell
//    }
//
//
//}
