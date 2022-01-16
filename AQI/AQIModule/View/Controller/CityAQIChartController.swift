//
//  CityAQIChartController.swift
//  AQI
//
//  Created by Rohan Chhatbar on 15/01/22.
//

import UIKit
import Charts

protocol AQIDelegate: AnyObject {
    func updateChart(cities: [CityAQIModel])
}

class CityAQIChartController: UIViewController,ChartViewDelegate {
    
    var isNeedToAdd = false
    var timeIntervalForUpdateChart = 10 // seconds
    var city: CityAQIModel?
    var tempArray: [CityAQIModel] = []
    var chartsvalue : [ChartDataEntry] = []
    
    @IBOutlet var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
    }
    
    fileprivate func configView() {
        Timer.scheduledTimer(timeInterval: TimeInterval(timeIntervalForUpdateChart), target: self, selector: #selector(pressedTimer), userInfo: nil, repeats: true)
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        
        chartView.backgroundColor = .white
        
        chartView.legend.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .topInside
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = Double(timeIntervalForUpdateChart)
        xAxis.valueFormatter = DateValueFormatter()
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 500
        leftAxis.yOffset = -9
        leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        
        chartView.rightAxis.enabled = false
        
        chartView.legend.form = .line
        
        updateChartData()
    }
    
    @objc func pressedTimer() {
        self.isNeedToAdd = true
    }
    
    func updateChartData() {
        if let selectedCity = self.city {
            self.title = selectedCity.city.capitalized + " AQI Chart"
            self.setDataCount(selectedCity)
        }
        
    }
    
    fileprivate func updateChartData(_ selectedCity: CityAQIModel) {
        chartsvalue.removeAll()
        self.tempArray.append(selectedCity)
        var timesArray = [Date]()
        
        let now = self.tempArray.first?.timestamp ?? 0.0
        let myTimeInterval = TimeInterval(now)
        var time = Date(timeIntervalSince1970: myTimeInterval)
        for _ in 0..<self.tempArray.count {
            timesArray.append(time)
            time.addTimeInterval(TimeInterval(timeIntervalForUpdateChart))
        }
        
        for (newindex,newtime) in timesArray.enumerated() {
            let newcity = self.tempArray[newindex]
            let y = Double(newcity.aqi.format(f: ".2")) ?? 0.0
            let entry = ChartDataEntry(x: Double(newtime.timeIntervalSince1970), y: Double(y))
            chartsvalue.append(entry)
        }
    }
    
    func setDataCount(_ selectedCity: CityAQIModel) {
        
        updateChartData(selectedCity)
        
        let set1 = LineChartDataSet(entries: chartsvalue, label: "DataSet 1")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.lineWidth = 1.5
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = false
        set1.fillAlpha = 0.26
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        
        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        
        chartView.data = data
        
        chartView.setNeedsDisplay()
        
    }
    
}

extension CityAQIChartController: AQIDelegate {
    func updateChart(cities: [CityAQIModel]) {
        if let city = self.city {
            if let firstIndex = cities.firstIndex(where: { oldcity in
                return oldcity.city == city.city
            }) {
                if isNeedToAdd {
                    self.isNeedToAdd = false
                    self.setDataCount(cities[firstIndex])
                }
                
            }
        }
    }
}

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm:ss"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
