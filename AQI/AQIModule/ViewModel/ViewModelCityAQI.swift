//
//  ViewModelCityAQI.swift
//  AQI
//
//  Created by Rohan Chhatbar on 15/01/22.
//

import Foundation

class ViewModelCityAQI: NSObject {
    weak var uDelegate:AQIDelegate?
    
    var updateListToController : (() -> ()) = {}
    
    var cities : [CityAQIModel] = [] {
        didSet {
            self.updateListToController()
        }
    }
        
    override init() {
        super.init()
        
        SocketHelper.instance.message = { message in
            self.convertToModelAndUpdateArray(message)
        }
    }
    
    fileprivate func convertToModelAndUpdateArray(_ message: Any) {
        if let text = message as? String,let response_cities = text.getCitiesList(){
            if self.cities.isEmpty {
                self.cities = response_cities
            } else {
                for (_,city) in response_cities.enumerated() {
                    let contains = self.cities.contains { oldcity in
                        return oldcity.city.lowercased() == city.city.lowercased()
                    }
                    
                    if contains {
                        if let firstIndex = self.cities.firstIndex(where: { oldcity in
                            return oldcity.city.lowercased() == city.city.lowercased()
                        }) {
                            self.cities[firstIndex].aqi = city.aqi
                            self.cities[firstIndex].timestamp = Date().timeIntervalSince1970
                        }
                    } else {
                        self.cities.insert(city, at: 0)
                    }
                }
            }
            
            self.uDelegate?.updateChart(cities: self.cities)
        }
    }
}

