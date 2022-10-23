//
//  ViewController.swift
//  Weather
//
//  Created by Kitja  on 15/10/2565 BE.
//

import UIKit
import Kingfisher


class DetailVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var firstCollectioView: UICollectionView!
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
    var test = [SetCollectionViewData]()
    var foreCast:ForeCase5Day?
    var foreCastArray = [ForeCase5Day.ForeCast]()
    var day = Calendar.current.component(.weekday, from: Date())
    let country = Country()
    var airData = [Int]()
    var lastCollectArray = [DetailVcModel]()
    
    
    override func viewDidLoad() {
        print("This is day \(day)")
        super.viewDidLoad()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let result = dateFormatter.string(from: date)
        
        lastCollectioView.dataSource = self
        lastCollectioView.delegate = self
        lastCollectioView.layer.cornerRadius = 15
        lastCollectioView.register(UINib(nibName: "LastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LastCollectionViewCell")

        
        
        firstCollectioView.dataSource = self
        firstCollectioView.delegate = self
        firstCollectioView.layer.cornerRadius = 15
        firstCollectioView.register(UINib(nibName: "FirstCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FirstCollectionViewCell")
        
        dayTableView.dataSource = self
        dayTableView.delegate = self
        dayTableView.register((UINib(nibName: "DetailVcCell", bundle: nil)), forCellReuseIdentifier: "DetailVcCell")
        dayTableView.layer.cornerRadius = 15
        
        airTableView.dataSource = self
        airTableView.delegate = self
        airTableView.register((UINib(nibName: "DetailAirVcCell", bundle: nil)), forCellReuseIdentifier: "DetailAirVcCell")
        airTableView.layer.cornerRadius = 15
        
       

        
    }
    
   
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        passDataFromApiCall(name: country.countryList.randomElement()!)
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
                    DispatchQueue.main.async {
                        self.airData = []
                        self.airData.append(airDataFromApi.data.current.pollution.aqius)
                        self.setupLastCollectionView(data: airDataFromApi)
                        guard let cityName = self.cityName else {return}
                        self.nameLabel.text = cityName.name
                        self.tempLabel.text = "\(Int((cityName.main.temp?.rounded(.down))!))°"
                        self.CodeLabel.text = cityName.weather[0].description?.capitalized
                        self.hightLabel.text = "H:\(Int((cityName.main.temp_max?.rounded(.down))!))°"
                        self.lowLabel.text = "L:\(Int((cityName.main.temp_min?.rounded(.down))!))°"
                        self.firstCollectioView.reloadData()
                        self.dayTableView.reloadData()
                        self.airTableView.reloadData()
                        self.lastCollectioView.reloadData()
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
            var data = SetCollectionViewData.init(temp: tempData.temperature_2m[i], time: index[i],code:String(tempData.weathercode[i]))
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
        var setCollectionView:[SetCollectionViewData]?
        guard let tempData = tempData?.hourly.temperature_2m else {
            return
        }
        for i in 0...tempData.count{
            index.append(i)
        }
    }
    
    func filterArrayWithTime(){
        test = []
        for i in collection.indices{
            if collection[i].time! >= hour{
                test.append(collection[i])
            }
        }
        
        for i in test.indices{
            if test[i].time == 25  {
                test[i].time = 1
            }
            else if test[i].time == 24  {
                test[i].time = 00
            }
            else if test[i].time == 26  {
                test[i].time = 2
            }
            else if test[i].time == 27  {
                test[i].time = 3
            }
            else if test[i].time == 28  {
                test[i].time = 4
            }
            else if test[i].time == 29  {
                test[i].time = 5
            }
            else if test[i].time == 30  {
                test[i].time = 6
            }
            else if test[i].time == 31  {
                test[i].time = 7
            }
            else if test[i].time == 32  {
                test[i].time = 8
            }
            else if test[i].time == 33  {
                test[i].time = 9
            }
            else if test[i].time == 34  {
                test[i].time = 10
            }
            else if test[i].time == 35  {
                test[i].time = 11
            }
            else if test[i].time == 36  {
                test[i].time = 12
            }
            else if test[i].time == 37  {
                test[i].time = 13
            }
            else if test[i].time == 38  {
                test[i].time = 14
            }
            else if test[i].time == 39  {
                test[i].time = 15
            }
            else if test[i].time == 40  {
                test[i].time = 16
            }
            else if test[i].time == 41  {
                test[i].time = 17
            }
            else if test[i].time == 42  {
                test[i].time = 18
            }
            else if test[i].time == 43  {
                test[i].time = 19
            }
            else if test[i].time == 44  {
                test[i].time = 20
            }
            else if test[i].time == 45  {
                test[i].time = 21
            }
            else if test[i].time == 46  {
                test[i].time = 22
            }
            else if test[i].time == 47  {
                test[i].time = 23
            }
            else if test[i].time == 48  {
                test[i].time = 00
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
    
    func setupLastCollectionView(data:Welcome){
        
        lastCollectArray = []
        
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
        
        print("THIS IS THE LAST COLLECTION \(lastCollectArray)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == firstCollectioView {
            return test.count ?? 0
        }else if collectionView == lastCollectioView {
            print(lastCollectArray.count)
            return lastCollectArray.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == firstCollectioView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCollectionViewCell", for: indexPath) as! FirstCollectionViewCell
            cell.mainLabels.text = "\(String(describing: test[indexPath.row].temp!))°"
            if test[indexPath.row].time == hour{
                cell.dateLabel.text = "Now"
            }else{
                cell.dateLabel.text = "\(String(describing: test[indexPath.row].time!))"
            }
            
            cell.mainImage.image = UIImage(systemName: test[indexPath.row].code!)
            return cell
            
        }else if collectionView == lastCollectioView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastCollectionViewCell", for: indexPath) as! LastCollectionViewCell
            
            cell.headerLabel.text = lastCollectArray[indexPath.row].header
            cell.mainLabel.text = lastCollectArray[indexPath.row].main
            cell.detailLabel.text = lastCollectArray[indexPath.row].deta
            cell.view.layer.cornerRadius = 15
            return cell
        }
        return UICollectionViewCell()
        
    }
    
//   func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        switch kind {
//            
//        case UICollectionView.elementKindSectionHeader:
//            
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath as IndexPath)
//            
//            headerView.backgroundColor = UIColor.blue
//            return headerView
//            
//        case UICollectionView.elementKindSectionFooter:
//            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath as IndexPath)
//            
//            footerView.backgroundColor = UIColor.green
//            return footerView
//            
//        default:
//            
//            assert(false, "Unexpected element kind")
//        }
//    }
}

extension DetailVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dayTableView{
            return foreCastArray.count ?? 0
        }else if tableView == airTableView{
            return airData.count
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
            cell.airLabel.text = "\(airData[0])"
            return cell
                
            }
        return UITableViewCell()
        }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == dayTableView{
            return "5-DAY FORECAST"
        }else if tableView == airTableView{
            return " AIR QUALITY"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
        
      
    }
}



