//
//  ViewController.swift
//  AQI
//
//  Created by Rohan Chhatbar on 15/01/22.
//

import UIKit

class CityAQIController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ViewModelCityAQI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
    }
    
    fileprivate func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(
            CityAQIHeaderView.nib,
            forHeaderFooterViewReuseIdentifier:
                CityAQIHeaderView.reuseIdentifier
        )
    }
    
    fileprivate func configView() {
        self.setupTableView()
        
        self.viewModel.updateListToController = {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppSegue.aqiTochart {
            let selectedCity = sender as! CityAQIModel
            let destination = segue.destination as! CityAQIChartController
            destination.city = selectedCity
            viewModel.uDelegate = destination
        }
    }
}

extension CityAQIController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.cities.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CityAQIHeaderView.reuseIdentifier)
                as? CityAQIHeaderView
        else {
            return nil
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityAQICell.reuseIdentifier, for: indexPath) as! CityAQICell
        cell.selectionStyle = .none
        cell.model = self.viewModel.cities[indexPath.row]
        
        // pressed for City
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pressedCity))
        tapGesture.numberOfTapsRequired = 1
        cell.lblCityName.tag = indexPath.row
        cell.lblCityName.isUserInteractionEnabled = true
        cell.lblCityName.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    @objc func pressedCity(sender:UITapGestureRecognizer) {
        if let lblCityName = sender.view as? UILabel {
            let selectedCity = self.viewModel.cities[lblCityName.tag]
            self.performSegue(withIdentifier: AppSegue.aqiTochart, sender: selectedCity)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
