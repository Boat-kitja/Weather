//
//  AllWeatherData.swift
//  Weather
//
//  Created by Kitja  on 26/10/2565 BE.
//

import Foundation

struct AllWeatherData {
    var firstSection:CityName?
    var hourlyForecast:[SetCollectionViewData]
    var dayForecast:[ForeCase5Day.ForeCast]?
    var airQuility:[Int?]
    var other:[DetailVcModel]
    var index:Int
}
