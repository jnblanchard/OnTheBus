//
//  ViewController.swift
//  OnTheBus
//
//  Created by John Blanchard on 8/5/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var busArray:NSArray = NSArray()
    var currDict:NSDictionary = NSDictionary()
    var middleBusCoordinate:CLLocationCoordinate2D!

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getJson()
    }

    func getJson()
    {
        var urlRequest = NSURLRequest(URL: NSURL(string: "https://s3.amazonaws.com/mobile-makers-lib/bus.json"))
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
            var dic:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary!
            self.busArray = dic["row"] as NSArray
            var count = 0
            for bus in self.busArray {
                if let bus = bus as? NSDictionary {
                    let  pointAnnotation = MKPointAnnotation()
                    let lat = bus["latitude"] as NSString
                    let long = bus["latitude"] as NSString
                    let coordinate = CLLocationCoordinate2DMake(lat.doubleValue, long.doubleValue)
                    if count == (self.busArray.count-1)/2  {
                        self.middleBusCoordinate = coordinate
                    }
                    count++
                    pointAnnotation.coordinate = coordinate
                    pointAnnotation.title = bus["cta_stop_name"] as String
                    pointAnnotation.subtitle = bus["routes"] as String
                    self.mapView.addAnnotation(pointAnnotation)
                }
            }
            let coordinateSpan = MKCoordinateSpanMake(0.55, 0.55)
            let myRegion = MKCoordinateRegion(center: self.middleBusCoordinate, span: coordinateSpan)
            self.mapView.setRegion(myRegion, animated: true)
        })
    }


    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
        return pin
    }

    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        var centerCoordinate = view.annotation.coordinate
        var coordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        var myRegion = MKCoordinateRegionMake(centerCoordinate, coordinateSpan)
        self.mapView.setRegion(myRegion, animated: true)
        for bus in self.busArray {
            let lat = bus["latitude"] as NSString
            if lat.doubleValue == view.annotation.coordinate.latitude {
                println("YES")
                currDict = bus as NSDictionary

            }
        }
        self.performSegueWithIdentifier("id", sender: nil)
    }



    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let bs:BusStopViewController = segue.destinationViewController as BusStopViewController
        bs.dict = self.currDict
    }

    @IBAction func `switch`(sender: AnyObject) {
        let seg:UISegmentedControl = sender as UISegmentedControl
        mapView.hidden = !mapView.hidden
        tableView.hidden = !tableView.hidden
        if seg.selectedSegmentIndex == 1 {
            tableView.reloadData()
        } else {

        }
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        let bus = busArray[indexPath.row] as NSDictionary
        cell.textLabel.text = bus["cta_stop_name"] as String
        return cell
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return busArray.count
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        currDict = busArray[indexPath.row] as NSDictionary
        self.performSegueWithIdentifier("id", sender: nil)
    }
}

