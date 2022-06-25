//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by ADMIN on 23/06/22.
//

import UIKit
import CoreLocation

// AlertViewHandlerProtocol defines method to show message using UIAlertController.
// HomeViewController provide the actual implementation
protocol AlertViewHandlerProtocol {
    func alertView(title: String, message: String)
}

// HomeViewController is the initial view controller
class HomeViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var sortButton: UIButton!
    private var isDateDsc: Bool = false
    // object of CLLocationManager is createdto receive lattitude and longitude for getting current location
    lazy var locationManager: CLLocationManager? = {
        let locationData =  CLLocationManager()
        return locationData
    }()
    var weatherVM: WeatherViewModel = WeatherViewModel()
    var weatherData: Weather?
    // sortButtonAction method is used to sort data in the tableview based on date
    @IBAction func sortButtonAction(_ sender: Any) {
        if self.isDateDsc {
            self.weatherData?.list.sort(by: {$0.date < $1.date})
            if let image = UIImage(named: Constants.dsc_image) {
                self.sortButton.setImage(image, for: .normal)
            }
        } else {
            self.weatherData?.list.sort(by: {$0.date > $1.date})
            if let image = UIImage(named: Constants.asc_image) {
                self.sortButton.setImage(image, for: .normal)
            }
        }
        self.isDateDsc = !self.isDateDsc
        self.weatherTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLocation()
        self.searchTextField.delegate = self
        self.searchTextField.placeholder = Constants.searchPlaceHolder
        self.weatherVM.alertViewDelegate = self
        
        self.weatherVM.result.bind { [weak self] result in
            if result != nil {
                self?.weatherData = result
                DispatchQueue.main.async {
                    self?.weatherTableView.reloadData()
                    if let temperatureString = self?.weatherData?.list.first?.main.temp {
                        self?.temperatureLabel.text = String(temperatureString)
                    }
                    self?.cityLabel.text = self?.weatherData?.city.name
                    // Set sort button image
                    if let image = UIImage(named: Constants.dsc_image) {
                        self?.sortButton.setImage(image, for: .normal)
                    }
                }
            }
        }
    }
    // Request the location and update the location. Set HomeViewController as the delegate of CLLocationManager
    func getLocation() {
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.requestLocation()
        self.locationManager?.startUpdatingLocation()
    }
}
// MARK: Delegate methods of Location Manager to report location-related events
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Location is received. So call weatherWebApi by sending location details and fetch the data
            let inputData = WeatherInput(
                lat: String(describing: location.coordinate.latitude),
                lon: String(describing: location.coordinate.longitude),
                city: "",
                type: Constants.weatherInputLocation)
            weatherVM.fetchWeather(inputData)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
// MARK: Delegate and Datasource methods for UITableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherData?.list.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherTableViewCell", for: indexPath) as? WeatherTableViewCell else {
            fatalError("Unable to dequeue the Cell")
        }
        cell.configureCell(self.weatherData?.list[indexPath.row])
        return cell
    }
}
// MARK: Methods to manage the editing and validation of search text
extension HomeViewController: UITextFieldDelegate {
    @IBAction func searchButtonTapped(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            textField.placeholder = Constants.searchPlaceHolder
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let selectedCity = searchTextField.text {
            let cityName = selectedCity.replacingOccurrences(of: " ", with: "%20")
            let inputData = WeatherInput(
                lat: "",
                lon: "",
                city: cityName,
                type: Constants.weatherInputCity)
            weatherVM.fetchWeather(inputData)
        }
        searchTextField.text = ""
        searchTextField.placeholder = Constants.searchPlaceHolder
    }
}
// MARK: Method of the custom protocol AlertViewHandlerProtocol
// It is used to show the message using UIAlertController
extension HomeViewController: AlertViewHandlerProtocol {
     func alertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
