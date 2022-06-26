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
    @IBOutlet weak var hoursCollectionView: UICollectionView!
    private var isDateDsc: Bool = false
    var weatherDataUniqueArray: [WeatherDataUnique]?
    var listUniqueDaysArray: [List]? = []
    // object of CLLocationManager is createdto receive lattitude and longitude for getting current location
    lazy var locationManager: CLLocationManager? = {
        let locationData =  CLLocationManager()
        return locationData
    }()
    var weatherVM: WeatherViewModel = WeatherViewModel()
    var weatherData: Weather?
    // sortButtonAction method is used to sort data in the tableview based on date
    @IBAction func sortButtonAction(_ sender: Any) {
        self.listUniqueDaysArray?.reverse()
        if self.isDateDsc {
            if let image = UIImage(named: Constants.dsc_image) {
                self.sortButton.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(named: Constants.asc_image) {
                self.sortButton.setImage(image, for: .normal)
            }
        }
        self.isDateDsc = !self.isDateDsc
        self.weatherTableView.reloadData()
        self.hoursCollectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "home_bg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.getLocation()
        self.searchTextField.delegate = self
        self.searchTextField.placeholder = Constants.searchPlaceHolder
        self.weatherVM.alertViewDelegate = self
        self.weatherTableView.backgroundColor = UIColor(red: 36/255, green: 120/255, blue: 183/255, alpha: 1.0)
        self.hoursCollectionView.backgroundColor = UIColor(red: 36/255, green: 120/255, blue: 183/255, alpha: 1.0)
        self.weatherVM.result.bind { [weak self] result in
            if result != nil {
                self?.weatherData = result
                DispatchQueue.main.async {
                    self?.createListArrayOnUniqueDays(weatherDates: self?.weatherData?.list ?? [])
                    self?.weatherTableView.reloadData()
                    self?.hoursCollectionView.reloadData()
                    if let temperatureString = self?.weatherData?.list.first?.main.temp {
                        self?.temperatureLabel.text = String(format: "%.0f", temperatureString)
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
    // For UICollectionView
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            if let flowLayout = self.hoursCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.itemSize = CGSize(width: self.hoursCollectionView.bounds.width, height: 120)
            }
    }
    func createListArrayOnUniqueDays(weatherDates: [List]) {
        self.listUniqueDaysArray = []
        var daysArray: [String] = []
        for list in weatherDates {
            daysArray.append(list.date.formatDate(.day))
        }
       daysArray = daysArray.unique()
       for day in daysArray {
           let weatherDataPerDay = weatherDates.filter { $0.date.formatDate(.day) == day }
            if let dayList = weatherDataPerDay.first {
                self.listUniqueDaysArray?.append(dayList)
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
        return self.listUniqueDaysArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherTableViewCell", for: indexPath) as? WeatherTableViewCell else {
            fatalError("Unable to dequeue the Cell")
        }
        var weatherDataUnique: WeatherDataUnique = WeatherDataUnique()
        weatherDataUnique.day = self.listUniqueDaysArray?[indexPath.row].date.formatDate(.day)
        weatherDataUnique.climate = self.listUniqueDaysArray?[indexPath.row].weatherDescription[0].description
        if let temperatureValue = self.listUniqueDaysArray?[indexPath.row].main.temp {
            weatherDataUnique.temperature = String(format: "%.0f", temperatureValue)
        }
        cell.configureCell(weatherDataUnique)
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
// MARK: Delegate and Datasource methods for UICollectionView
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weatherData?.list.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hoursCell", for: indexPath) as! HoursCollectionViewCell
        cell.timeLabel.text = self.weatherData?.list[indexPath.row].date.formatDate(.hour)
        if let temperature = self.weatherData?.list[indexPath.row].main.temp {
            cell.temperatureLabel.text = String(format: "%.0f", temperature)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // print(indexPath.item + 1)
    }
}
