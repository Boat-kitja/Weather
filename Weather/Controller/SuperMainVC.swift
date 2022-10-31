//
//  SuperMainVC.swift
//  Weather
//
//  Created by Kitja  on 27/10/2565 BE.
//

import UIKit

class SuperMainVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    

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
    var currentPage = 0
    

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
       
        pageControll.numberOfPages = CityDataForMainView.shared.cirysData.count
        pageControll.currentPage = indexForAllWeatherData
        
       
        
        print("on detailcontroller \(currentPage)")
        
        moveToIndexPath()
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moveToIndexPath()
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        collectionView.reloadData()
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
            if let setTor = setupData.firstSection{
                vc.titleText = setTor.name
                vc.tempText = "\(setTor.main.temp!)°"
            }
           
           
        }
      
        vc.modalPresentationStyle = .fullScreen

        present(vc, animated: true, completion: nil)
    }
    

    func moveToIndexPath(){
       
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.reloadData()
        print(indexPath)
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControll.currentPage = indexPath.row
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    
    
   
    


}
