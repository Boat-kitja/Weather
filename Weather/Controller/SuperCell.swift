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
    
    @IBOutlet weak var hourlyTableView: UITableView!
    @IBOutlet weak var dayTableView: UITableView!
    
    @IBOutlet weak var ariTableView: UITableView!
    
    @IBOutlet weak var lastCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    
    var setupData:AllWeatherData?
    
    var day = Calendar.current.component(.weekday, from: Date())
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        _ = dateFormatter.string(from: date)
        
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.layer.cornerRadius = 15
        collectionView.register(UINib(nibName: "LastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LastCollectionViewCell")
        
        dayTableView.dataSource = self
        dayTableView.register(UINib(nibName: "DetailVcCell", bundle: nil), forCellReuseIdentifier: "DetailVcCell")
        dayTableView.layer.cornerRadius = 15
        
        hourlyTableView.dataSource = self
        
        hourlyTableView.register(FirstTableViewCell.nib(), forCellReuseIdentifier: FirstTableViewCell.identifier)
        hourlyTableView.layer.cornerRadius = 15
        
        ariTableView.dataSource = self
        ariTableView.register((UINib(nibName: "DetailAirVcCell", bundle: nil)), forCellReuseIdentifier: "DetailAirVcCell")
        ariTableView.layer.cornerRadius = 15
        
        
        
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
        dayTableView.reloadData()
        hourlyTableView.reloadData()
        ariTableView.reloadData()
        collectionView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dayTableView {
            return setupData?.dayForecast?.count ?? 0
        }else if tableView == hourlyTableView {
            return 1
        }else if tableView == ariTableView{
            return setupData?.airQuility.count ?? 0
        }
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dayTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailVcCell", for: indexPath) as! DetailVcCell
            switch day {
            case 1 :
                cell.daysLabel.text = SevenDay.sharedInstance.day1[indexPath.row]
            case 2 :
                cell.daysLabel.text = SevenDay.sharedInstance.day2[indexPath.row]
            case 3 :
                cell.daysLabel.text = SevenDay.sharedInstance.day3[indexPath.row]
            case 4 :
                cell.daysLabel.text = SevenDay.sharedInstance.day4[indexPath.row]
            case 5 :
                cell.daysLabel.text = SevenDay.sharedInstance.day5[indexPath.row]
            case 6 :
                cell.daysLabel.text = SevenDay.sharedInstance.day6[indexPath.row]
            case 7 :
                cell.daysLabel.text = SevenDay.sharedInstance.day7[indexPath.row]
            default :
                cell.daysLabel.text = "non"
            }
            
            if let setCell = setupData?.dayForecast?[indexPath.row].weather[0].conditionName{
                cell.codeImage.image = UIImage(systemName: setCell)
            }
            
            cell.htempLabel.text = "H:\(Int((setupData?.dayForecast?[indexPath.row].main.temp_max?.rounded(.down))!) )°"
            cell.ltempLabel.text = "L:\(Int((setupData?.dayForecast?[indexPath.row].main.temp_min?.rounded(.down))!) )°"
            return cell
            
        }else if tableView == hourlyTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FirstTableViewCell.identifier, for: indexPath) as! FirstTableViewCell
            if let setcell = setupData?.hourlyForecast{
                cell.test = setcell
                cell.collectionView.reloadData()
            }
            return cell
        }else if
            tableView == ariTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailAirVcCell", for: indexPath) as! DetailAirVcCell
            if let airData = setupData?.airQuility {
                if airData[0] != nil {
                    cell.airLabel.text = "\(airData[0]!)"
                    cell.meter.value = CGFloat(Float(airData[0]!)/100)
                    if airData[0]! < 50 {
                        cell.airStatusLabel.text = "GOOD"
                        cell.airDetailLabel.text = "Air quality is satisfactory, and air pollution poses little or no risk."
                    }else if airData[0]! < 99 {
                        cell.airStatusLabel.text = "SATTISFACTORY"
                        cell.airDetailLabel.text = "Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution."
                    }else {
                        cell.airStatusLabel.text = "POOR"
                        cell.airDetailLabel.text = "Members of sensitive groups may experience health effects. The general public is less likely to be affected."
                    }
                }else {
                    cell.airLabel.text = "ERROR"
                    cell.airStatusLabel.text = "ERROR"
                }
            }
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == dayTableView{
            return "5-DAY FORECAST"
        }else if tableView == ariTableView{
            return "AIR QUALITY"
        }else if tableView == hourlyTableView{
            return "HOURLY FORECAST"
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
        
        
    }
}

extension SuperCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setupData?.other.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastCollectionViewCell", for: indexPath) as! LastCollectionViewCell
        
        if let setCell = setupData?.other[indexPath.row]{
            cell.headerLabel.text = setCell.header
            cell.mainLabel.text = setCell.main
            cell.detailLabel.text = setCell.deta
            cell.view.layer.cornerRadius = 15

        }
        return cell
    }
    
    
}
