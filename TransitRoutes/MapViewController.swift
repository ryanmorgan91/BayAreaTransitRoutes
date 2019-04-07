//
//  ViewController.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 3/29/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet fileprivate weak var mapView: GMSMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    let marker = GMSMarker()
    let path = GMSMutablePath()
    
    var route: Route!
    let transitController = TransitController()
    let directionsController = DirectionsController()
    var busInformation = [BusInformation]()
    var busOperators: [BusOperator]?
    var busPosition: CLLocationCoordinate2D?
    var origin: CLLocationCoordinate2D?
    var vehicleRef: String?
    var stopId: String?
    var lineRef: String?
    var stringOrigin: String?
    var busesAndDistances = [BusAndDistance]()
    var filteredBusByLineAndDirection = [VehicleActivity]()
    var bussesAndPosition = [BusAndPosition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mapView.delegate = self
        mapView.settings.rotateGestures = true
        mapView.clear()
        
        transitController.fetchOperatorIDs(completion: { (busOperators) in
            DispatchQueue.main.async {
                self.busOperators = busOperators
                self.convertGoogleDirections()
                self.addBusToMap()
            }
        })

        addPolylinesAndUpdateCamera()
    }

    func showMarker(position: CLLocationCoordinate2D) {
       // Take in parameter named position of type CLLocationCoordinate and places map marker at position on mapView.
        
        marker.position = position
        marker.map = mapView
    }
    
    func addPolylinesAndUpdateCamera() {
        
        // Adds polylines to mapView
        guard let overviewPolyline = route.overviewPolyline else {return}
        guard let points = overviewPolyline.points else {return}
        let path = GMSPath(fromEncodedPath: points)
        let mappedPolyline = GMSPolyline(path: path)
        mappedPolyline.map = mapView
        
        guard let legs = route.legs else {return}
        guard let steps = legs[0].steps else {return}
        for step in steps {
            guard let polyline = step.polyline else {return}
            guard let points = polyline.points else {return}
            let path = GMSPath(fromEncodedPath: points)
            let mappedPolyline = GMSPolyline(path: path)
            mappedPolyline.map = mapView
        }
        guard let startLocation = steps[0].startLocation else {return}
        
        //Focuses comera on origin
        self.stringOrigin = "\(startLocation.lat), \(startLocation.lng)"
        self.origin = CLLocationCoordinate2D(latitude: startLocation.lat, longitude: startLocation.lng)
        let camera = GMSCameraPosition(target: origin!, zoom: 11.0, bearing: 0, viewingAngle: 0)
        mapView.camera = camera
    }
        
    func convertGoogleDirections() {
        // Converts the transit operator/agency name returned by Google's API to the same transit operator/agency ID (a different two letter naming convention) used by 511Transit's APIs.  The app requests a list of agencies/operators from 511 Transit's Operators API. Next the app matches up the 511Transit agency names to the agencies names returned by 511's Operators API. The app then creates an array of BusInformation object's with the converted operator_id / agency.
        
        guard let legs = route.legs else {return}
        guard let steps = legs[0].steps else {return}
  
        for step in steps {
           
            guard let transitDetails = step.transitDetails else { continue }
            guard let arrivalStop = transitDetails.arrivalStop else {continue}
            guard let departureStop = transitDetails.departureStop else {continue}
            guard let line = transitDetails.line else {continue}
            guard var agencies = line.agencies else {continue}
            guard let name = agencies[0].name else { continue }
            guard let busLineRef = line.shortName else {continue}
            
            guard let filteredBusOperator = busOperators!.first(where: { $0.name == name }) else {continue}
            guard let id = filteredBusOperator.id else {continue}
            
            busInformation.append(BusInformation(operatorId: id, lineRef: busLineRef, arrivalStop: arrivalStop, departureStop: departureStop))

        }
    }
    
    func addBusToMap() {
        // Pulls a list of bus stops by agency/operator and matches the name of that stop to the name of the stop provided by Google's Directions API.
        let bus = busInformation[0]
        self.lineRef = bus.lineRef
        
        transitController.fetchStopId(forOperatorId: bus.operatorId) { (busStop) in
            guard let mappedBusStops = busStop?.compactMap({ $0.busStopContents  }).compactMap({ $0.dataObjects  }).compactMap({ $0.scheduledStopPoint  }).flatMap({ $0  }) else {return}
            guard let identifiedBusStop = mappedBusStops.first(where: { $0.name == bus.departureStop.name }) else {return}
            guard let identifiedBusStopId = identifiedBusStop.id else {return}
            self.stopId = identifiedBusStopId
            
            // Using the agency/operator id and the bus lineRef from Google's Directions API, the app pulls a list of busses on that line and their vehicle activity and location.  In my experience, the 511 Vehicle Monitoring API returns up to 4 busses: two traveling in the same direction and two traveling in the opposite direction.
            
            self.transitController.fetchBusLocation(forOperatorId: bus.operatorId, forLineRef: bus.lineRef) { (busLocation) in
                
                guard let bussesTravelingInLine = busLocation?.compactMap({ $0.siri.serviceDelivery.vehicleMonitoringDelivery.vehicleActivity }).flatMap({ $0 }) else {return}
              
                // The app then filters the list of busses traveling in that line (bussesTravelingInLine) based on the direction the bus is traveling in.  This was necessary because Google's Directions API doesn't include the direction of the bus line. The app determines the direction the bus is traveling by matching the departure stop provided by Google's Directions API with the OnwardCall provided by 511's VehicleMonitoring API.

                self.filterBusByLineAndDirection(forBusArray: bussesTravelingInLine, completion: {
                    
                    // Uses narrowsDownToClosestBus to sort the busses by closest distance to the user's bus stop.  The map places a marker on the mapView at the current location of the bus.  It also updates the distanceLabel to indicate the distance of the bus from the stop.  The app pulls the bus' distance from the stop using Google's Directions API.
                    
                    self.narrowDownToClosestBus(forFilteredBusByLineAndDirection: self.bussesAndPosition)  })
            }
        }
    }
    
    func filterBusByLineAndDirection(forBusArray bussesTravelingInLine: [VehicleActivity], completion: @escaping () -> ()) {

        for eachBus in bussesTravelingInLine {
            guard let busLatitudeDouble = Double(eachBus.monitoredVehicleJourney.vehicleLocation.latitude) else {continue}
            guard let busLongitudeDouble = Double(eachBus.monitoredVehicleJourney.vehicleLocation.longitude) else {continue}
            
            for callData in eachBus.monitoredVehicleJourney.onwardCall!.callData! {
                if callData.stopPointRef == self.stopId {
                    
                    if eachBus.monitoredVehicleJourney.lineRef == self.lineRef {
  
                        let busPosition = CLLocationCoordinate2D(latitude: busLatitudeDouble, longitude: busLongitudeDouble)
                        let busAndPosition = BusAndPosition(vehicleActivity: eachBus, position: busPosition)
                        self.bussesAndPosition.append(busAndPosition)
                    }
                }
            }
        }
        completion()
    }
    
    func narrowDownToClosestBus(forFilteredBusByLineAndDirection filteredBusByLineAndDirection: [BusAndPosition]) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        for busAndPosition in bussesAndPosition {
        
            // Uses narrowsDownToClosestBus to sort the busses by closest distance to the user's bus stop.  The map places a marker on the mapView at the current location of the bus.  It also updates the distanceLabel to indicate the distance of the bus from the stop.  The app pulls the bus' distance from the stop using Google's Directions API.

            dispatchGroup.enter()
            let stringDestination = "\(busAndPosition.position.latitude),\(busAndPosition.position.longitude)"
            self.directionsController.fetchBusDistance(forOrigin: self.stringOrigin!, forDestination: stringDestination, completion: { (directions) in
            
            guard let directions = directions else {return}
            guard let routes = directions.routes else {return}
            guard let legs = routes[0].legs else {return}
            guard let distance = legs[0].distance?.value else {return}
            guard let distanceString = legs[0].distance?.text else {return}
            let busAndDistance = BusAndDistance(distance: distance, distanceString: distanceString, vehicleActivity: busAndPosition.vehicleActivity, position: busAndPosition.position)
            self.busesAndDistances.append(busAndDistance)
                
            dispatchGroup.leave()
            })
        }
        
        dispatchGroup.leave()
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.updateUI()
        }
    }
    
    func updateUI() {

        self.busesAndDistances.sort { $0.distance < $1.distance }
        let correctBus = self.busesAndDistances[0]
        self.distanceLabel.text = "Bus Distance From Stop: \(correctBus.distanceString)"
        self.showMarker(position: correctBus.position)
    }
    
}


