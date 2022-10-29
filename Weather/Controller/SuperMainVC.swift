//
//  SuperMainVC.swift
//  Weather
//
//  Created by Kitja  on 27/10/2565 BE.
//

import UIKit

class SuperMainVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    

    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    var airData:[Int?] = []
    var lastCollectArray = [DetailVcModel]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
       

        
    }
//    
//    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
//        print("plus")
//        if pageControll.currentPage != CityDataForMainView.shared.cirysData.count {
//            if indexForAllWeatherData != CityDataForMainView.shared.cirysData.count - 1{
//                indexForAllWeatherData = indexForAllWeatherData + 1
//                pageControll.currentPage = indexForAllWeatherData
//                setupData = CityDataForMainView.shared.cirysData[indexForAllWeatherData]
//                print(setupData)
//                allreloadData()
//            }
//            
//        }
//        
//    }
    
//    @IBAction func goBack(_ sender: Any) {
//        self.dismiss(animated: true)
//    }
//
//    @IBAction func swipeMinus(_ sender: Any) {
//        print("minus")
//        if pageControll.currentPage != 0 {
//            indexForAllWeatherData = indexForAllWeatherData - 1
//            pageControll.currentPage = indexForAllWeatherData
//            setupData = CityDataForMainView.shared.cirysData[indexForAllWeatherData]
//            allreloadData()
//    }
//    }
//
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return CityDataForMainView.shared.cirysData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuperCell", for: indexPath) as! SuperCell
        
        cell.setupData = CityDataForMainView.shared.cirysData[indexPath.row]
     
        cell.allreloadData()
//        cell.dayTableView.reloadData()
        
        return cell
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
   
    


}
