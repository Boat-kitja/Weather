//
//  MapVc.swift
//  Weather
//
//  Created by Kitja  on 27/10/2565 BE.
//

import UIKit
import CoreLocation
import MapKit

class MapVc: UIViewController,MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    
    
    var titleText:String!
    var tempText:String!
    var lat:Double!
    var lon:Double!
    var coordinate = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(map)
//        map.frame = view.bounds
   
        
        coordinate.latitude = lat
        coordinate.longitude = lon
        
        
        map.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
        print(coordinate)
        
        map.delegate = self
        
        myPin()
    }
    
    private func myPin(){
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = titleText!
        if let tempText = tempText{
            pin.subtitle = tempText
        }
        
        map.addAnnotation(pin)
    }
    
    @IBAction func goBack(_ sender: Any){
        self.dismiss(animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        
        var annotationVIew = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotationVIew == nil {
            annotationVIew = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationVIew?.canShowCallout = true
            
        }else{
            annotationVIew?.annotation = annotation
        }
        
        annotationVIew?.image = UIImage(systemName: "mappin.and.ellipse")
        
        return annotationVIew
    }
    


}
