//
//  MainViewController.swift
//  xPallet
//
//  Created by Kevin Wang on 11/23/15.
//  Copyright © 2015 xPallet Inc. All rights reserved.
//

import UIKit
import Mapbox

class MainViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var btnCustomizeMove: UIButton!
    @IBOutlet weak var locationInfoContainer: UIView!
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var btnDirectGps: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var btnCloseMenu: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    
    var menuNames = ["Home", "Profile", "History", "Payment", "Settings", "Help", "About"]
    var locationManager: CLLocationManager!
    
    var flag = true
    var geoCoder: CLGeocoder!
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geoCoder = CLGeocoder()
        mapView.delegate = self
        mapView.zoomLevel = 15
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let tapViewGesture = UITapGestureRecognizer(target: self, action: "dismissMenu:")
        let tapLabelGesture = UITapGestureRecognizer(target: self, action: "tapLocationField:")
        self.labelContainer.addGestureRecognizer(tapLabelGesture)
        self.mapView.addGestureRecognizer(tapViewGesture)
        self.mapView.compassView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.setPlacePoint()
        flag = true
    }
    
    @IBAction func tapMenuButton(sender: AnyObject) {
        self.menuView.hidden = false
        if flag {
            let height = self.menuView.frame.height
            let width = self.menuView.frame.width
            let y = self.menuView.frame.origin.y
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.menuView.frame = CGRectMake(0, y, width, height)
                }, completion: nil)
        } else {
            self.dismissMenuWithAnimation(8)
        }
        flag = !flag
    }
    
    @IBAction func tapCustomizeMove(sender: AnyObject) {
        self.dismissMenuWithAnimation(7)
    }
    
    @IBAction func tapRightArrow(sender: AnyObject) {
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("locationSearchView") as! LocationSearchViewController, animated: true)
    }
    
    @IBAction func getCurrentLocation(sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }
    
    func dismissMenu(sender: AnyObject){
        dismissMenuWithAnimation(8)
    }
    
    func tapLocationField(sender: AnyObject){
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("locationSearchView") as! LocationSearchViewController, animated: true)
    }
    
    func setPlacePoint(){
        let latitude = NSUserDefaults.standardUserDefaults().objectForKey(pickUpLatitude)
        let longitude = NSUserDefaults.standardUserDefaults().objectForKey(pickUpLongitude)
        if latitude != nil {
            let pointLocation = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
            self.mapView.setCenterCoordinate(pointLocation, zoomLevel: 15, animated: true)
            self.setLocationNameTextField(CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees))
        }
    }
    
    func dismissMenuWithAnimation (index: Int) {
        
        let height = self.menuView.frame.height
        let width = self.menuView.frame.width
        let y = self.menuView.frame.origin.y
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.menuView.frame = CGRectMake(-240, y, width, height)
            }, completion: { (Bool) -> Void in
                self.flag = true
                self.menuTableView.reloadData()
                switch index {
                case 0:
                    break
                case 1:
                    self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("profileViewController") as! ProfileViewController, animated: true)
                    break
                case 2:
                    break
                case 3:
                    self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("paymentViewController") as! PaymentsViewController, animated: true)
                    break
                case 4:
                    break
                case 5:
                    break
                case 6:
                    break
                case 7:
                    self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("customizeMoveVIew") as! CustomizeMoveViewController, animated: true)
                    break
                case 8:
                    break
                default:
                    break
                }
        })
    }
    
    func setLocationNameTextField(location: CLLocation){
        geoCoder.reverseGeocodeLocation(location) { (placeMarks: [CLPlacemark]?, error: NSError?) -> Void in
            if error == nil {
                var locationName = ""
                let place = placeMarks![0]
                if let placeName = place.addressDictionary!["Name"] as? String{
                    locationName.appendContentsOf(placeName)
                }
                if let placeStreet = place.addressDictionary!["Thoroughfare"] as? String{
                    locationName.appendContentsOf(" \(placeStreet)")
                }
                if let placeCity = place.addressDictionary!["City"] as? String{
                    locationName.appendContentsOf(" \(placeCity)")
                }
                if let zipCode = place.addressDictionary!["ZIP"] as? String {
                    locationName.appendContentsOf(" \(zipCode)")
                }
                if let country = place.addressDictionary!["Country"] as? String {
                    locationName.appendContentsOf(" \(country)")
                }
                self.lblLocation.text = locationName
            }
        }
    }
    
    // MARK: UITableView DataSource and Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNames.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MenuTableCell
        menuCell.menuName.text = menuNames[indexPath.row]
        menuCell.menuIcon.image = UIImage(named: self.menuNames[indexPath.row].lowercaseString)
        menuCell.titleBack.hidden = true
        
        menuCell.selectionStyle = UITableViewCellSelectionStyle.None
        return menuCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuTableCell
        cell.titleBack.hidden = false
        //Action
        self.dismissMenuWithAnimation(indexPath.row)
    }
    
    // MARK: CLLocationManager Delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last! as CLLocation
        let currentPoint = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        self.setLocationNameTextField(currentLocation)
        mapView.setCenterCoordinate(currentPoint, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: MapView Delegate
    func mapViewRegionIsChanging(mapView: MGLMapView) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        self.setLocationNameTextField(location)
    }
}