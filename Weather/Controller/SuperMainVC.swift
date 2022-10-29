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
    var setupData:AllWeatherData?
    
    var indexForAllWeatherData:Int!

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
       
        pageControll.numberOfPages = CityDataForMainView.shared.cirysData.count
        pageControll.currentPage = indexForAllWeatherData 
        
    }
    
   
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

    
    
    @IBAction func mapPress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapVc") as! MapVc
        if let setupData = setupData {
            vc.lat = Double((setupData.firstSection?.coord.lat)!)
            vc.lon = Double((setupData.firstSection?.coord.lon)!)
            vc.titleText = setupData.firstSection?.name
            vc.tempText = "\(setupData.firstSection?.main.temp!)"
        }
      
        vc.modalPresentationStyle = .fullScreen
       
        present(vc, animated: true, completion: nil)
    }
    

    
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
