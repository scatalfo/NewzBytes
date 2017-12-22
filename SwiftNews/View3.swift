//
//  View3.swift
//  SwiftNews
//
//  Created by Benjamin Catalfo on 9/3/17.
//  Copyright © 2017 CatalfoProductions. All rights reserved.
//
/*
import Foundation
import GoogleMaps
import UIKit

class View3: UIViewController, GMSMapViewDelegate {
    private var mapView: GMSMapView!
    private var heatmapLayer: GMUHeatmapTileLayer!
    private var button: UIButton!
    
    private var gradientColors = [UIColor.green, UIColor.red]
    private var gradientStartPoints = [0.2, 1.0] as? [NSNumber]
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: -37.848, longitude: 145.001, zoom: 10)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        self.view = mapView
        makeButton()
    }
    
    override func viewDidLoad() {
        // Set heatmap options.
        heatmapLayer = GMUHeatmapTileLayer()
        heatmapLayer.radius = 80
        heatmapLayer.opacity = 0.8
        heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                            startPoints: gradientStartPoints!,
                                            colorMapSize: 256)
        addHeatmap()
        
        // Set the heatmap to the mapview.
        heatmapLayer.map = mapView
    }
    
    // Parse JSON data and add it to the heatmap layer.
    func addHeatmap()  {
        print("TEST224")
        let asset = NSDataAsset(name: "police_stations", bundle: Bundle.main)
        let json = try? JSONSerialization.jsonObject(with: asset!.data, options: JSONSerialization.ReadingOptions.allowFragments)
        print(json)

        var list = [GMUWeightedLatLng]()
        do {
            // Get the data: latitude/longitude positions of police stations.
                if let object = json as? [[String: Any]] {
                    for item in object {
                        let lat = item["lat"]
                        print(lat)
                        print("TEST123TEST123")
                        let lng = item["lng"]
                        print(lng)
                        let coords = GMUWeightedLatLng(coordinate: CLLocationCoordinate2DMake(lat as! CLLocationDegrees, lng as! CLLocationDegrees), intensity: 1.0)
                        list.append(coords)
                    }
            }
        } catch {
            print(error.localizedDescription)
        }
        // Add the latlngs to the heatmap layer.
        heatmapLayer.weightedData = list
    }
    
    @objc func removeHeatmap() {
        /*
        heatmapLayer.map = nil
        heatmapLayer = nil
        // Disable the button to prevent subsequent calls, since heatmapLayer is now nil.
        button.isEnabled = false
         */
        self.performSegue(withIdentifier: "exitMap", sender: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    // Add a button to the view.
    func makeButton() {
        // A button to test removing the heatmap.
        button = UIButton(frame: CGRect(x: 0, y: 20, width: 200, height: 35))
        button.backgroundColor = .blue
        button.alpha = 0.5
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(removeHeatmap), for: .touchUpInside)
        self.mapView.addSubview(button)
    }
}
*/
import GoogleMaps
import UIKit
import Firebase
/// Point of Interest Item which implements the GMUClusterItem protocol.
class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}

let kCameraLatitude = 40.9387363
let kCameraLongitude = -73.09803469999997

class View3: UIViewController, GMUClusterManagerDelegate, GMSMapViewDelegate {
    private var button: UIButton!

    private var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: kCameraLatitude,
                                              longitude: kCameraLongitude, zoom: 10)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the cluster manager with default icon generator and renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        // Generate and add random items to the cluster manager.
        generateClusterItems()
        
        // Call cluster() after items have been added to perform the clustering and rendering on map.
        clusterManager.cluster()
        
        // Register self to listen to both GMUClusterManagerDelegate and GMSMapViewDelegate events.
        clusterManager.setDelegate(self, mapDelegate: self)
        makeButton()

    }
    

    
    // MARK: - GMUClusterManagerDelegate
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        return false
    }
    
    // MARK: - GMUMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.name)")
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
    }
    func makeButton() {
        // A button to test removing the heatmap.
        button = UIButton(frame: CGRect(x: 0, y: 20, width: 200, height: 35))
        button.backgroundColor = .blue
        button.alpha = 0.5
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(removeHeatmap), for: .touchUpInside)
        self.mapView.addSubview(button)
    }
    @objc func removeHeatmap() {
        /*
         heatmapLayer.map = nil
         heatmapLayer = nil
         // Disable the button to prevent subsequent calls, since heatmapLayer is now nil.
         button.isEnabled = false
         */
        self.performSegue(withIdentifier: "exitMap", sender: nil)
    }


    
    // MARK: - Private
    
    /// Randomly generates cluster items within some extent of the camera and adds them to the
    /// cluster manager.
    private func generateClusterItems() {
        let ref = Database.database().reference()
        ref.child("articles").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            let article = Article()
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                if (snap.key == "lat"){
                    article.lat = snap.value as? Double
                }
                if (snap.key == "long"){
                    article.long = snap.value as? Double
                }
                if (snap.key == "title"){
                    article.headline = snap.value as? String
                }

            }
            let lat = article.lat
            let lng = article.long
            let name = article.headline
            let item = POIItem(position: CLLocationCoordinate2DMake(lat ?? 0, lng ?? 0), name: name ?? "")
            self.clusterManager.add(item)

        })
        
    }
    
    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
}

