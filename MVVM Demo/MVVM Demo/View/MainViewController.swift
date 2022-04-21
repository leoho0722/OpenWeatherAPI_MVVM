//
//  MainViewController.swift
//  MVVM Demo
//
//  Created by Leo Ho on 2022/4/21.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var showPickerButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var cityPickerViewBottomConstraint: NSLayoutConstraint!

    var mainViewControllerViewModel =  MainViewControllerViewModel()
    
    var isShowPicker: Bool = false
    
    var selectCityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityPickerView.delegate = self
        
        cityPickerView.dataSource = self
        
        mainViewControllerViewModel.mainViewControllerViewModelDelegate = self
        
        cityLabel.text = "Please select the city you want to query"
        
        showPickerView(isShowPickerView: false) // 隱藏 PickerView
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showPickerView(isShowPickerView: false) // 點空白處，關閉 PickerView
    }

    @IBAction func showPickerBtnClicked(_ sender: UIButton) {
        isShowPicker = !isShowPicker
        showPickerView(isShowPickerView: isShowPicker) // 顯示 PickerView
    }
    
    @IBAction func startSearchBtnClicked(_ sender: UIButton) {
        guard selectCityName != nil else {
            Alert().yesAlert(title: "Please select the city you want to query first", message: nil, confirmTitle: "Close", vc: self, completionHandler: nil)
            return
        }
        
        showPickerView(isShowPickerView: false)
        
        mainViewControllerViewModel.fetchWeatherData(city: selectCityName!)
    }
    
    func showPickerView(isShowPickerView: Bool) {
        if (isShowPickerView) {
            cityPickerViewBottomConstraint.constant = 0
            isShowPicker = !isShowPickerView
        } else {
            cityPickerViewBottomConstraint.constant = 300
        }
    }
    
}

extension MainViewController: MainViewControllerViewModelDelegate {
    
    func didFetchWeatherData(data: WeatherData) {
        DispatchQueue.main.async {
            let cityName = self.mainViewControllerViewModel.cityNameURLFormatter(city: self.selectCityName!)
            let lon = data.coord.lon
            let lat = data.coord.lat
            let temp = Int(data.main.temp / 10)
            let humidity = data.main.humidity
            let results = "City：\(cityName)\nLongitude：\(lon)\nLatitude：\(lat)\nTemperature：\(temp)°C\nHumidity：\(humidity)%"
            
            Alert().yesAlert(title: "Weather Results", message: results, confirmTitle: "Close", vc: self, completionHandler: nil)
        }
    }
    
}

extension MainViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mainViewControllerViewModel.cityList.count
    }

}

extension MainViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCityName = mainViewControllerViewModel.cityListURL[row]
        cityLabel.text = mainViewControllerViewModel.cityNameURLFormatter(city: selectCityName!)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mainViewControllerViewModel.cityList[row]
    }
    
}

// MARK: - 參考教學
/*
 https://youtu.be/7HKi96v4X2A
 */
