//
//  ViewController.swift
//  Weather
//
//  Created by Kitja  on 15/10/2565 BE.
//

import UIKit
import Kingfisher

protocol RefreshDataDelegate {
  func refreshData()
}


class DetailVCFromSearch: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
   
    @IBOutlet weak var sengmentControl: UISegmentedControl!
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    //    @IBOutlet weak var firstCollectioView: UICollectionView!
    @IBOutlet weak var firstTableView: UITableView!
    @IBOutlet weak var dayTableView: UITableView!
    @IBOutlet weak var airTableView: UITableView!
    @IBOutlet weak var lastCollectioView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var CodeLabel: UILabel!
    @IBOutlet weak var hightLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    
    let setDataCollect = SetCollectionViewData()
    let api = APIManger()
    let searchBar = UISearchController()
    var cityName:CityName?
    var tempData:WeatherData?
    let data = Date()
    var newDict = [Int:Float]()
    let hour = Calendar.current.component(.hour, from: Date())
    var collection = [SetCollectionViewData]()
    var index = [Int]()
    var hourForecast = [SetCollectionViewData]()
    var foreCast:ForeCase5Day?
    var foreCastArray = [ForeCase5Day.ForeCast]()
    var day = Calendar.current.component(.weekday, from: Date())
    let country = Country()
    var airData:[Int?] = []
    var lastCollectArray = [DetailVcModel]()
    var delegate:RefreshDataDelegate?
    var meterForSlide = -1
//    var indexNAJA = [Int]()
    
    
    override func viewDidLoad() {
//        print("this is dog color \(mainView.layer.backgroundColor)")
        super.viewDidLoad()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        _ = dateFormatter.string(from: date)
        
       
        
        lastCollectioView.dataSource = self
        lastCollectioView.delegate = self
        lastCollectioView.layer.cornerRadius = 15
        lastCollectioView.backgroundColor = mainView.backgroundColor
        lastCollectioView.register(UINib(nibName: "LastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LastCollectionViewCell")
        
        
        
//        firstCollectioView.dataSource = self
//        firstCollectioView.delegate = self
//        firstCollectioView.layer.cornerRadius = 15
//        firstCollectioView.register(UINib(nibName: "FirstCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FirstCollectionViewCell")
        
        dayTableView.dataSource = self
        dayTableView.delegate = self
        dayTableView.register((UINib(nibName: "DetailVcCell", bundle: nil)), forCellReuseIdentifier: "DetailVcCell")
        dayTableView.layer.cornerRadius = 15
        
        airTableView.dataSource = self
        airTableView.delegate = self
        airTableView.register((UINib(nibName: "DetailAirVcCell", bundle: nil)), forCellReuseIdentifier: "DetailAirVcCell")
        airTableView.layer.cornerRadius = 15
        
        firstTableView.dataSource = self
        firstTableView.delegate = self
        firstTableView.register(FirstTableViewCell.nib(), forCellReuseIdentifier: FirstTableViewCell.identifier)
        firstTableView.layer.cornerRadius = 15
        
       
       
        
    }
    
    
    @IBAction func addDataToMainView(_ sender: Any) {
        let data = AllWeatherData.init(firstSection: self.cityName,
                                       hourlyForecast: self.hourForecast,
                                       dayForecast: self.foreCastArray,
                                       airQuility: self.airData,
                                       other: self.lastCollectArray,
                                       index:CityDataForMainView.shared.cirysData.count)
        CityDataForMainView.shared.cirysData.append(data)
//        print(CityDataForMainView.shared.cirysData)
        print(data)
        delegate?.refreshData()
        self.dismiss(animated: true)
        

    }
    
    func passDataFromApiCall(name:String){
        api.LatAndLon(cityName: name) { dataFirst in
            self.cityName = dataFirst
            self.api.apiCallHour(location: dataFirst) { [self] data in
                self.tempData = data
                self.setupNewData()
                self.setCollection()
                self.filterArrayWithTime()
                self.api.foreCast(name: cityName!.name) { forecast in
                    self.foreCast = forecast
                    self.setForeCastDay()
                    self.api.airAPI(location: dataFirst) { airDataFromApi in
                        DispatchQueue.main.async { [self] in
                            
                                self.airData = []
                            self.airData.append(airDataFromApi?.data.current.pollution.aqius ?? nil)
                                self.setupLastCollectionView(data: airDataFromApi)
                          
                            
                            if let cityName = self.cityName {
                            self.nameLabel.text = cityName.name
                            self.tempLabel.text = "\(Int((cityName.main.temp?.rounded(.down))!))°"
                            self.CodeLabel.text = cityName.weather[0].description?.capitalized
                            self.hightLabel.text = "H:\(Int((cityName.main.temp_max?.rounded(.down))!))°"
                            self.lowLabel.text = "L:\(Int((cityName.main.temp_min?.rounded(.down))!))°"
//                            self.firstCollectioView.reloadData()
                            self.dayTableView.reloadData()
                            self.airTableView.reloadData()
                            self.lastCollectioView.reloadData()
                            self.firstTableView.reloadData()
//                            self.mainView.backgroundColor = .random
                            self.lastCollectioView.backgroundColor = mainView.backgroundColor
                            } else {
                                self.nameLabel.text = "no name"
                                self.tempLabel.text = "no name"
                                self.CodeLabel.text = "no name"
                                self.hightLabel.text = "no name"
                                self.lowLabel.text = "no name"
    //                            self.firstCollectioView.reloadData()
                                self.dayTableView.reloadData()
                                self.airTableView.reloadData()
                                self.lastCollectioView.reloadData()
                                self.firstTableView.reloadData()
//                                self.mainView.backgroundColor = .random
                                self.lastCollectioView.backgroundColor = mainView.backgroundColor
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setCollection(){
        collection = []
        guard let tempData = tempData?.hourly else {
            return
        }
        for i in 0...48 {
            let data = SetCollectionViewData.init(temp: tempData.temperature_2m[i], time: index[i],code:String(tempData.weathercode[i]))
            collection.append(data)
        }
        for i in 0...48{
            switch collection[i].code {
            case "1" :
                collection[i].code = "sun.min"
            case "2" :
                collection[i].code = "cloud.snow"
            case "3" :
                collection[i].code = "tornado"
            case "4" :
                collection[i].code = "cloud.fog"
            case "5" :
                collection[i].code = "cloud.drizzle"
            case "6" :
                collection[i].code = "cloud.rain"
            case "7" :
                collection[i].code = "snowflake"
            case "8" :
                collection[i].code = "cloud.rain"
            case "9" :
                collection[i].code = "cloud.bolt.rain.fill"
            default:
                collection[i].code = "cloud.sun"
            }
        }
    }
    
    func setupNewData(){
        var _:[SetCollectionViewData]?
        guard let tempData = tempData?.hourly.temperature_2m else {
            return
        }
        for i in 0...tempData.count{
            index.append(i)
        }
    }
    
    func filterArrayWithTime(){
        hourForecast = []
        for i in collection.indices{
            if collection[i].time! >= hour{
                hourForecast.append(collection[i])
            }
        }
        
        for i in hourForecast.indices{
            if hourForecast[i].time == 25  {
                hourForecast[i].time = 1
            }
            else if hourForecast[i].time == 24  {
                hourForecast[i].time = 00
            }
            else if hourForecast[i].time == 26  {
                hourForecast[i].time = 2
            }
            else if hourForecast[i].time == 27  {
                hourForecast[i].time = 3
            }
            else if hourForecast[i].time == 28  {
                hourForecast[i].time = 4
            }
            else if hourForecast[i].time == 29  {
                hourForecast[i].time = 5
            }
            else if hourForecast[i].time == 30  {
                hourForecast[i].time = 6
            }
            else if hourForecast[i].time == 31  {
                hourForecast[i].time = 7
            }
            else if hourForecast[i].time == 32  {
                hourForecast[i].time = 8
            }
            else if hourForecast[i].time == 33  {
                hourForecast[i].time = 9
            }
            else if hourForecast[i].time == 34  {
                hourForecast[i].time = 10
            }
            else if hourForecast[i].time == 35  {
                hourForecast[i].time = 11
            }
            else if hourForecast[i].time == 36  {
                hourForecast[i].time = 12
            }
            else if hourForecast[i].time == 37  {
                hourForecast[i].time = 13
            }
            else if hourForecast[i].time == 38  {
                hourForecast[i].time = 14
            }
            else if hourForecast[i].time == 39  {
                hourForecast[i].time = 15
            }
            else if hourForecast[i].time == 40  {
                hourForecast[i].time = 16
            }
            else if hourForecast[i].time == 41  {
                hourForecast[i].time = 17
            }
            else if hourForecast[i].time == 42  {
                hourForecast[i].time = 18
            }
            else if hourForecast[i].time == 43  {
                hourForecast[i].time = 19
            }
            else if hourForecast[i].time == 44  {
                hourForecast[i].time = 20
            }
            else if hourForecast[i].time == 45  {
                hourForecast[i].time = 21
            }
            else if hourForecast[i].time == 46  {
                hourForecast[i].time = 22
            }
            else if hourForecast[i].time == 47  {
                hourForecast[i].time = 23
            }
            else if hourForecast[i].time == 48  {
                hourForecast[i].time = 00
            }
        }
    }
    
    func setForeCastDay(){
        guard let foreCast = foreCast else {
            return
        }
        foreCastArray = []
        foreCastArray.append(foreCast.list[6])
        foreCastArray.append(foreCast.list[18])
        foreCastArray.append(foreCast.list[25])
        foreCastArray.append(foreCast.list[32])
        foreCastArray.append(foreCast.list[38])
    }
    
    func setupLastCollectionView(data:Welcome?){
        lastCollectArray = []
        if let data = data {
            let temp = data.data.current.weather.tp
            let setup = DetailVcModel.init(header: "FEEL LIKE", main: "\(temp)°", deta: "Similar to the actual temperature.")
            lastCollectArray.append(setup)
            
            let temp1 = data.data.current.weather.hu
            let setup1 = DetailVcModel.init(header: "HUMIDITY", main: "\(temp1)%", deta: "The dex point is 13° right now")
            lastCollectArray.append(setup1)
            
            let temp2 = data.data.current.weather.ws
            let setup2 = DetailVcModel.init(header: "WIND", main: "\(temp2) km/h", deta: "XXXXXXXXXXXXXX")
            lastCollectArray.append(setup2)
            
            let temp3 = data.data.current.weather.pr
            let setup3 = DetailVcModel.init(header: "PRESSURE", main: "\(temp3) hpa", deta: "XXXXXXXXXXXXXX")
            lastCollectArray.append(setup3)
        }else{
            let temp = "ERROR"
            let setup = DetailVcModel.init(header: "FEEL LIKE", main: "\(temp)°", deta: "Similar to the actual temperature.")
            lastCollectArray.append(setup)
            
            let temp1 = "ERROR"
            let setup1 = DetailVcModel.init(header: "HUMIDITY", main: "\(temp1)%", deta: "The dex point is 13° right now")
            lastCollectArray.append(setup1)
            
            let temp2 = "ERROR"
            let setup2 = DetailVcModel.init(header: "WIND", main: "\(temp2) km/h", deta: "XXXXXXXXXXXXXX")
            lastCollectArray.append(setup2)
            
            let temp3 = "ERROR"
            let setup3 = DetailVcModel.init(header: "PRESSURE", main: "\(temp3) hpa", deta: "XXXXXXXXXXXXXX")
            lastCollectArray.append(setup3)
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            return lastCollectArray.count
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
   
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastCollectionViewCell", for: indexPath) as! LastCollectionViewCell
            
            cell.headerLabel.text = lastCollectArray[indexPath.row].header
            cell.mainLabel.text = lastCollectArray[indexPath.row].main
            cell.detailLabel.text = lastCollectArray[indexPath.row].deta
            cell.view.layer.cornerRadius = 15
        
            return cell
       
        
    }
    
    
}

extension DetailVCFromSearch:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dayTableView{
            return foreCastArray.count 
        }else if tableView == airTableView{
            return airData.count
        }else if tableView == firstTableView{
            return 1
        }
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dayTableView{
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
            
            cell.codeImage.image = UIImage(systemName: foreCastArray[indexPath.row].weather[0].conditionName)
            
            cell.htempLabel.text = "H:\(Int((foreCastArray[indexPath.row].main.temp_max?.rounded(.down))!) )°"
            cell.ltempLabel.text = "L:\(Int((foreCastArray[indexPath.row].main.temp_min?.rounded(.down))!) )°"
            
            return cell
            
        } else if
            tableView == airTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailAirVcCell", for: indexPath) as! DetailAirVcCell
        
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
            
            return cell
            
        }else if
            tableView == firstTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: FirstTableViewCell.identifier, for: indexPath) as! FirstTableViewCell
            
            cell.test = hourForecast
            cell.collectionView.reloadData()
            
            return cell
            
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == dayTableView{
            return "5-DAY FORECAST"
        }else if tableView == airTableView{
            return "AIR QUALITY"
        }else if tableView == firstTableView{
            return "HOURLY FORECAST"
        }

        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
        
        
    }
}

extension UIColor {
    class var random: UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}





