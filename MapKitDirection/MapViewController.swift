//
//  MapViewController.swift
//  MapKitDirection
//
//  Created by Pablo Mateo Fernández on 27/01/2017.
//  Copyright © 2017 355 Berry Street S.L. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let offset: Double = 10000
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var myViewTest: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var restaurant:Restaurant!
    let locationManager = CLLocationManager()
    var currentPlacemark: CLPlacemark?
    var currentTransporte = MKDirectionsTransportType.automobile
    var currentRuta: MKRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.requestWhenInUseAuthorization()//Para pedir la autorizacion
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.authorizedWhenInUse{
        
        mapView.showsUserLocation = true
        segmentedControl.isHidden = true
        segmentedControl.addTarget(self, action: #selector(showDirection), for: .valueChanged)
            
        }
        
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler: { placemarks, error in
            if error != nil {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
            
        })
        
        mapView.delegate = self
        if #available(iOS 9.0, *) { //Detecta la version del OS
            mapView.showsCompass = true
            mapView.showsScale = true
            mapView.showsTraffic = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func localSearchPressed(_ sender: AnyObject) {
        
        let searchRequest = MKLocalSearchRequest() //Necesitamos un request que lo vamos a necesitar para hacer una busqueda
        searchRequest.naturalLanguageQuery = restaurant.type //Que propiedades tiene esta peticion,  como es un string y está escrito en lenguaje natural le decimos que esta escrito en lenguaje natural
        searchRequest.region = mapView.region //Para que busque en la region que queremos
        

        let localSearch = MKLocalSearch(request: searchRequest) //Creamos la variable local search y le enviamos la peticion
        localSearch.start { (response, error) in
            guard let response = response else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            let mapItems = response.mapItems //Creamos una variable donde nos guarda todos los puntos que ha devuelto la busqueda
            var nearbyAnnotations: [MKAnnotation] = [] //Creamos un array de anotaciones, donde guardaremos parte de la informacion que nos devuelve los items del mapa
            if mapItems.count > 0 { //Si ha encontrado algo
                for item in mapItems {
                //Añadir anotacion al mapa
                    let annotation = MKPointAnnotation()
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    if let location = item.placemark.location { //Si tiene localizacion 
                        annotation.coordinate = location.coordinate
                    }
                    nearbyAnnotations.append(annotation)
                }
            }
            self.mapView.showAnnotations(nearbyAnnotations, animated: true)
        }
    }
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(named: restaurant.image)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        // Pin color customization
        if #available(iOS 9.0, *) {
            annotationView?.pinTintColor = UIColor.orange
        }
        annotationView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)//Es el boton a la derecha del bocadillo
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "mostrarPasos", sender: view)
    }
    
    @IBAction func showDirection(_ sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex{
            case 0:
                currentTransporte = MKDirectionsTransportType.automobile
            case 1:
                currentTransporte = MKDirectionsTransportType.walking
            default:
                break;
        
        }
        
        segmentedControl.isHidden = false
        
        guard let currentPlacemark = currentPlacemark else {
        return
        }
        
        let directionRequest = MKDirectionsRequest()
        //Establecer punto de inicio y punto de llegada
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = currentTransporte //Le decimos que queremos ir en coche
        
        //Calcular direccion
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (routeResponse, routeError) in
            guard let routeResponse = routeResponse else {
                if let routeError = routeError{
                print("Error:\(routeError)")
                }
            return
            }
            let route = routeResponse.routes[0]
            self.currentRuta = route //Para pasarle la informacion por el segue
            self.mapView.removeOverlays(self.mapView.overlays) //Para eliminar las demas rutas y que solo se muestre 1 y no 2 al cambiar de tipo de ruta
            
            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)//Polyline una opcion que te da rout, te da, tiempo estimado, informacion.. otra es polyline que es que te la dibuje. En MKOverlayLevel es que se muestre encima de la informacion, debajo y demas opciones
            var rect = route.polyline.boundingMapRect//Crea un rectangulo con el tamaño de la ruta 
            rect.size.height += 5000
            rect.size.width += 5000
            
            rect.origin.x -= 2500
            rect.origin.y -= 2500
            
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (currentTransporte == .automobile) ? UIColor.blue : UIColor.orange
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarPasos"{
        let pasosTableVC = segue.destination.childViewControllers[0] as! PasosTableViewController
            if let pasos = currentRuta?.steps {
                pasosTableVC.pasosRuta = pasos
            }
        }
    }
    
    
    
}
