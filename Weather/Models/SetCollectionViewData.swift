//
//  SetCollectionViewData.swift
//  Weather
//
//  Created by Kitja  on 16/10/2565 BE.
//

import Foundation

struct SetCollectionViewData {
    var temp:Float?
    var time:Int?
    var code:String?
  
    mutating func setWeathernCode(Code:String) -> String{
        var newCode:String!
        switch Code {
        case "1" :
            newCode = "sum.min"
        case "2" :
            newCode = "cloud.snow"
        case "3" :
            newCode = "tornado"
        case "4" :
            newCode = "cloud.fog"
        case "5" :
            newCode = "cloud.drizzle"
        case "6" :
            newCode = "cloud.rain"
        case "7" :
            newCode = "snowflake"
        case "8" :
            newCode = "cloud.rain"
        case "9" :
            newCode = "cloud.bolt.rain.fill"
        default:
            newCode = "cloud.sun"
        }
        return newCode!
    }
}
    



