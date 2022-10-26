//
//  API.swift
//  Weather
//
//  Created by Kitja  on 15/10/2565 BE.
//

import Foundation

protocol PassDataToMainVC:AnyObject{
    func passData(data:WeatherData)
}

struct APIManger {
    weak var delegate:PassDataToMainVC?
    
    func LatAndLon(cityName:String, completion:@escaping(CityName)->Void) {
        let request = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=metric&appid=9185a5dae8e9325c40cefeb259c79ba9")
        let session = URLSession.shared
        guard let request = request else {
            return
        }
        
        let dataTask = session.dataTask(with: request) { data, rep, error in
            if error != nil{
                print("error")
            }else {
                guard let data = data else {
                    return
                }
                do{
                    let decode = try? JSONDecoder().decode(CityName.self, from: data)
                    if let decode = decode {
//                        print(decode)
                        completion(decode)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func apiCallHour(location:CityName,completion:@escaping(WeatherData)->Void){
        let lat = location.coord.lat?.formatted()
        
        let long = location.coord.lon?.formatted()
        
        guard let request = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat!)&longitude=\(long!)&hourly=temperature_2m,rain,weathercode&past_days=1")
                
                
        else { return }
//        print(request)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, respon, error in
            if error != nil{
                print("error")
            }
            else{
                do{
                    let decode = try? JSONDecoder().decode(WeatherData.self, from: data!)
                    if let decode = decode{
                        completion(decode)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func foreCast(name:String, completion:@escaping(ForeCase5Day) -> Void) {
        let request = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(name)&appid=9185a5dae8e9325c40cefeb259c79ba9&units=metric")
        let session = URLSession.shared
        guard let request = request else {
            return
        }

        let dataTask = session.dataTask(with: request) { data, rep, error in
            if error != nil{
                print("error")
            }else {
                guard let data = data else {
                    return
                }
                do{
                    let decode = try? JSONDecoder().decode(ForeCase5Day.self, from: data)
                    if let decode = decode {
//                        print("print this is forecasr dog \(decode)")
                        completion(decode)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func airAPI(location:CityName,completion:@escaping(Welcome?)->Void){
        let lat = location.coord.lat?.formatted()
        let long = location.coord.lon?.formatted()
        var decode:Welcome?
        
        let url = URL(string: "https://api.airvisual.com/v2/nearest_city?lat=\(lat!)&lon=\(long!)&key=83ed60aa-d063-40f6-8857-2f0459377958")
        
        let urlForNil = URL(string: "https://api.airvisual.com/v2/nearest_city?lat=\(lat!)&lon=\(long!)&key=88f55a2d-b569-40c5-982f-386ce00f10ad")
       
        let session = URLSession.shared

        let dataTask = session.dataTask(with: url!) { data, rep, error in
            if error != nil {
                print("error")
            }else {
                print("con go")

                do{
                    decode = try? JSONDecoder().decode(Welcome.self, from: data!
                    )
                    
                    
                }
//                print("This is dog \(decode) \(url)")
                if decode != nil {
                    completion(decode)
                }else {
                    let dataTask2 = session.dataTask(with: urlForNil!) { data2, rep, error in
                        if error != nil {
                            print("error")
                        }else {
                            print("backup can go")
                            do { decode =
                                try? JSONDecoder().decode(Welcome.self, from: data2!)
//                                print("This is backup plan \(decode) \(urlForNil)")
                                completion(decode)
                            } 
                        }
                    }
                    dataTask2.resume()
                }
                
            }
        }
        dataTask.resume()
    }
}

