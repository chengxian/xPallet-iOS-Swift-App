//
//  LocationSearchViewController.swift
//  xPallet
//
//  Created by ChengXian Lim on 12/15/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit
import HNKGooglePlacesAutocomplete
import Alamofire


class LocationSearchViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, CustomTextFieldDelegate {

    @IBOutlet weak var txtLocationtextfield: CustomTextField!
    @IBOutlet weak var locationTableView: UITableView!
    
    var locationManager: CLLocationManager!
    var placeSearchQuery:HNKGooglePlacesAutocompleteQuery!
    
    var geoCoder: CLGeocoder!
    var currentSelectedLocation: CLLocationCoordinate2D!
    var searchResultLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var placeSearchResult: [AnyObject] = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTableView.dataSource = self
        locationTableView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        
        placeSearchQuery = HNKGooglePlacesAutocompleteQuery.sharedQuery()
        placeSearchQuery.configuration.country = "us"
        placeSearchQuery.configuration.filter = HNKGooglePlaceTypeAutocompleteFilter.Address
        geoCoder = CLGeocoder()
        
        txtLocationtextfield.mDelegate = self
    }
    
    @IBAction func tapMenuButton(sender: AnyObject) {
        goBackToMain()
    }
    
    @IBAction func tapDeleteLocationText(sender: AnyObject) {
        if txtLocationtextfield.text != "" {
            txtLocationtextfield.text = ""
        } else {
            goBackToMain()
        }
    }
    
    @IBAction func tapCurrentLocation(sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func locationTextChange(sender: AnyObject) {
        self.searchResultLocations.removeAll()
        let searchText = self.txtLocationtextfield.text
        let temp = NSString(string: searchText!)
        if temp.length > 0{
            self.placeSearchQuery.fetchPlacesForSearchQuery(temp as String, completion: { (places, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    self.placeSearchResult = places
                    self.locationTableView.reloadData()
                }
            })
        } else {
            self.searchResultLocations.removeAll()
            self.placeSearchResult.removeAll()
            self.locationTableView.reloadData()
        }
    }
    
    func setLocationNameTextField(location: CLLocation){
        geoCoder.reverseGeocodeLocation(location) { (placeMarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error == nil {
                var locationName = ""
                let place = placeMarks![0]
                if let placeName = place.addressDictionary!["Name"] as? String{
                    locationName.appendContentsOf(placeName)
                }
                if let placeCity = place.addressDictionary!["City"] as? String{
                    locationName.appendContentsOf(", \(placeCity)")
                }
                self.txtLocationtextfield.text = locationName
            }
        }
    }
    
    func goBackToMain(){
        if currentSelectedLocation != nil {
            NSUserDefaults.standardUserDefaults().setObject(self.currentSelectedLocation.latitude, forKey: pickUpLatitude)
            NSUserDefaults.standardUserDefaults().setObject(self.currentSelectedLocation.longitude, forKey: pickUpLongitude)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: TableView Data Source and Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeSearchResult.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let placeCell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! LocationTableViewCell
        let place: HNKGooglePlacesAutocompletePlace = self.placeSearchResult[indexPath.row] as! HNKGooglePlacesAutocompletePlace
 
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/geocode/json", parameters: ["address": place.name]).responseJSON(completionHandler: { (response) -> Void in
            print(response)
            let placeResult = response.result.value?.valueForKey("results") as! [AnyObject]
            if placeResult.count > 0 {
                let placeAddress = placeResult[0].valueForKey("address_components") as! [AnyObject]
                let placeType = placeResult[0].valueForKey("types") as! [AnyObject]
                
                let locationLat = placeResult[0].valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat") as! Double
                let locationLong = placeResult[0].valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng") as! Double
                
                var locationName = ""
                var locationNameSmall = ""
                
                if placeType[0] as! String == "route" {
                    for value in placeAddress {
                        let types = value.valueForKey("types") as! [AnyObject]
                        let type = types[0] as! String
                        if type == "route" {
                            locationName = value.valueForKey("long_name") as! String
                        }
                        if type == "locality" {
                            let locality = value.valueForKey("long_name") as! String
                            locationNameSmall.appendContentsOf(locality + ", ")
                        }
                        if type == "administrative_area_level_2" {
                            let admini_2 = value.valueForKey("long_name") as! String
                            locationNameSmall.appendContentsOf(admini_2 + ", ")
                        }
                        if type == "administrative_area_level_1" {
                            let admini_1 = value.valueForKey("short_name") as! String
                            locationNameSmall.appendContentsOf(admini_1 + " ")
                        }
                        if type == "postal_code" {
                            let postal = value.valueForKey("long_name") as! String
                            locationNameSmall.appendContentsOf(postal)
                        }
                    }
                    placeCell.locationIcon.image = UIImage(named: "business")
                } else {
                    for value in placeAddress {
                        let types = value.valueForKey("types") as! [AnyObject]
                        let type = types[0] as! String
                        if type == "street_number" {
                            let street = value.valueForKey("long_name") as! String
                            locationName.appendContentsOf(street + ", ")
                        }
                        if type == "route" {
                            let route = value.valueForKey("long_name") as! String
                            locationName.appendContentsOf(route)
                        }
                        if type == "sublocality_level_1" {
                            let sub_local = value.valueForKey("long_name") as! String
                            locationName.appendContentsOf(" ," + sub_local)
                        }
                        if type == "locality" {
                            let locality = value.valueForKey("long_name") as! String
                            locationNameSmall.appendContentsOf(locality + ", ")
                        }
                        if type == "administrative_area_level_2" {
                            let admini_2 = value.valueForKey("long_name") as! String
                            locationNameSmall.appendContentsOf(admini_2 + ", ")
                        }
                        if type == "administrative_area_level_1" {
                            let admini_1 = value.valueForKey("short_name") as! String
                            locationNameSmall.appendContentsOf(admini_1 + " ")
                        }
                        if type == "postal_code" {
                            let postal = value.valueForKey("long_name") as! String
                            locationNameSmall.appendContentsOf(postal)
                        }
                    }
                    placeCell.locationIcon.image = UIImage(named: "pin_point")
                }
                placeCell.locationName.text = locationName
                placeCell.locationNameSmall.text = locationNameSmall
                self.searchResultLocations.append(CLLocationCoordinate2D(latitude: locationLat, longitude: locationLong))
            }
        })
        return placeCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        locationTableView.deselectRowAtIndexPath(indexPath, animated: true)
        txtLocationtextfield.resignFirstResponder()
        self.currentSelectedLocation = self.searchResultLocations[indexPath.row]
        self.goBackToMain()
    }
    
    // MARK: Location Manager Delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last! as CLLocation
        currentSelectedLocation = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        self.setLocationNameTextField(currentLocation)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: Custom Text Field Delegate
    func customTextFieldDidEndEditing(sender: AnyObject) {
        
    }
    
    func customTextFieldShouldReturn(sender: AnyObject) {
        txtLocationtextfield.resignFirstResponder()
    }
}
