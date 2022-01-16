//
//  CityAQICell.swift
//  AQI
//
//  Created by Rohan Chhatbar on 15/01/22.
//

import UIKit

class CityAQICell: UITableViewCell {
    
    static let reuseIdentifier: String = "CityAQICell"
    
    @IBOutlet weak var lblCityName: LableWithBorder!
    @IBOutlet weak var lblCityAQI: LableWithBorder!
    @IBOutlet weak var lblUpdatedTime: LableWithBorder!
    
    var model : CityAQIModel? {
        didSet {
            if let model = model {
                self.lblCityName.text = model.city
                self.lblCityAQI.text = model.aqi.format(f: ".2")
                let myTimeInterval = TimeInterval(model.timestamp)
                let time = Date(timeIntervalSince1970: myTimeInterval)
                self.lblUpdatedTime.text = time.timeAgoDisplay()                
                self.lblCityAQI.textColor = model.getColorFromCategory()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
