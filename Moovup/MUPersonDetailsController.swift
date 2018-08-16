//
//  MUPersonDetailsController.swift
//  Moovup
//
//  Created by Vishwa Bharath on 14/08/18.
//  Copyright © 2018 ViswaBharathD. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class MUPersonDetailsController: UIViewController,MKMapViewDelegate {

    var mapView: MKMapView!
    var selectedPersonData:MUPersonData!
    var placeholderImgVw: UIImageView!
    var titleLabel: UILabel!
    var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedPersonData.name
        buildScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buildScreen() {
        
        view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        let personPoint = MUCustomPointAnnotation()
        personPoint.title = selectedPersonData.name
        personPoint.subtitle = selectedPersonData.email
        personPoint.imageName = "map-pin"

        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300))
        mapView.delegate = self as MKMapViewDelegate
        mapView.mapType = MKMapType.satellite
        mapView.isScrollEnabled = false
        self.view.addSubview(mapView)
       
        // ** zoomToRegion ---------
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: selectedPersonData.location.latitude), longitude: CLLocationDegrees(truncating: selectedPersonData.location.longitude))
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        mapView.setRegion(region, animated: true)
        personPoint.coordinate = location
        mapView.addAnnotation(personPoint)
        mapView.selectAnnotation(personPoint, animated: true)
        
        // ** Add Container View ---------
        var y = mapView.frame.maxY
        let space:CGFloat = 10
        let containerView = UIView(frame: CGRect(x: space, y: y - 2*space, width: view.frame.size.width - 2*space, height: 120))
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 5
        y = space
        placeholderImgVw = UIImageView(frame: CGRect(x: y, y:y , width: 100, height: 100))
        placeholderImgVw.layer.cornerRadius = 5
        placeholderImgVw.layer.masksToBounds = true
        placeholderImgVw.sd_setImage(with: URL(string: selectedPersonData.picture!) , placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.highPriority, completed: nil)
                                    containerView.addSubview(placeholderImgVw)
                                    let xx = placeholderImgVw.frame.maxX + 15
        
        let subWidth = containerView.frame.size.width - 2*space - xx
        // ** Display details  ---------
        titleLabel = UILabel(frame: CGRect(x: xx, y:y, width: subWidth, height: 35))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = UIColor.black
        titleLabel.text = selectedPersonData.name
        containerView.addSubview(titleLabel)

        detailLabel = UILabel(frame: CGRect(x: xx, y:titleLabel.frame.maxY-10, width: subWidth, height: 35))
        detailLabel.text = selectedPersonData.email
        detailLabel.font = UIFont.systemFont(ofSize: 18)
        detailLabel.textColor = UIColor.darkGray
        containerView.addSubview(detailLabel)

        let personIDLabel = UILabel(frame: CGRect(x: xx, y:detailLabel.frame.maxY-10, width: subWidth, height: 35))
        personIDLabel.text =  selectedPersonData._id
        personIDLabel.font = UIFont.systemFont(ofSize: 15)
        personIDLabel.textColor = UIColor.gray
        containerView.addSubview(personIDLabel)

        let cordinatesLabel = UILabel(frame: CGRect(x: xx, y:personIDLabel.frame.maxY-13, width: subWidth, height: 35))
        cordinatesLabel.text =  String(format:"%@, %@",selectedPersonData.location.latitude, selectedPersonData.location.longitude)
        cordinatesLabel.font = UIFont.systemFont(ofSize: 12)
        cordinatesLabel.textColor = UIColor.lightGray
        containerView.addSubview(cordinatesLabel)
        self.view.addSubview(containerView)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.setSelected(true, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MUCustomPointAnnotation) {
            return nil
        }
        let identifier = "MUAnnotation"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
            anView?.setSelected(true, animated: true)

        let mucpa = annotation as! MUCustomPointAnnotation
        anView?.image = UIImage(named:mucpa.imageName)
        anView?.setSelected(true, animated: true)
        return anView
    }
 
}

class MUCustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

extension CGRect {
    var center : CGPoint  {
        get {
            return CGPoint(x:self.midX, y: self.midY)
        }
    }
}

