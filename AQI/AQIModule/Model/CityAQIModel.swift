//
//  CityAQIModel.swift
//  AQI
//
//  Created by Rohan Chhatbar on 15/01/22.
//

import UIKit

struct CityAQIModel : Codable {
    var city : String
    var aqi : Double
    var timestamp : Double
    var category: AQICategory?
    
    enum CodingKeys: String, CodingKey {
        
        case city = "city"
        case aqi = "aqi"
        case timestamp = "timestamp"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city = try values.decodeIfPresent(String.self, forKey: .city) ?? ""
        aqi = try values.decodeIfPresent(Double.self, forKey: .aqi) ?? 0.0
        timestamp = try values.decodeIfPresent(Double.self, forKey: .timestamp) ?? Date().timeIntervalSince1970
        self.category = self.setCategory()
    }
    
    func setCategory() -> AQICategory {
        switch self.aqi {
        case 0..<51:
            return .Good
        case 51..<101:
            return .Satisfactory
        case 101..<201:
            return .Moderate
        case 201..<301:
            return .Poor
        case 301..<401:
            return .VeryPoor
        case 401..<501:
            return .Severe
        default:
            return .none
        }
    }
    
    func getColorFromCategory() -> UIColor {
        guard let category = category else {
            return .black
        }
        
        switch category {
        case .Good:
            return UIColor(red: 0/255, green: 176/255, blue: 80/255, alpha: 1)
        case .Satisfactory:
            return UIColor(red: 146/255, green: 208/255, blue: 80/255, alpha: 1)
        case .Moderate:
            return UIColor(red: 250/255, green: 255/255, blue: 6/255, alpha: 1)
        case .Poor:
            return UIColor(red: 255/255, green: 153/255, blue: 0/255, alpha: 1)
        case .VeryPoor:
            return UIColor(red: 255/255, green: 2/255, blue: 0/255, alpha: 1)
        case .Severe:
            return UIColor(red: 191/255, green: 1/255, blue: 0/255, alpha: 1)
        default:
            return .black
        }
    }
    
}
