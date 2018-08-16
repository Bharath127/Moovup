//
//  ViewController.swift
//  Moovup
//
//  Created by Vishwa Bharath on 13/08/18.
//  Copyright © 2018 ViswaBharathD. All rights reserved.
//

import UIKit
import TableFlip
import SDWebImage
import Toast_Swift

let cellReuseIdentifier: String = "peopleCell"

class ViewController: UIViewController {
    
    var peopleData:Array<MUPersonData>!
    let store = MUDataStore.sharedInstance
    let headerFooterHeight:CGFloat = 50

    fileprivate lazy var tableListView: UITableView = {
        $0.dataSource = self as UITableViewDataSource
        $0.delegate = self as UITableViewDelegate
        $0.rowHeight = 80
        $0.separatorColor = .clear
        $0.separatorInset = .zero
        $0.backgroundColor = .white
        $0.sectionHeaderHeight = 5
        $0.sectionFooterHeight = 0
        $0.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        rc.tintColor = UIColor.red
        return rc
    }()
    
    override func loadView() {
        view = tableListView
    }

    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Moovup"
        self.tableListView.addSubview(self.refreshControl)
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            self.handleRefresh(self.refreshControl)
        }else{
            print("Internet Connection not Available!")
            self.laodOfflineData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: handleRefresh

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {

        refreshControl.beginRefreshing() // ** Start refreshing table
        
        store.getPeopleData { // ** Get people data from API store
            DispatchQueue.main.async {
                self.peopleData = self.store.peopleData
                print(self.peopleData)
                self.tableListView.reloadData()
                let myCoolTableAnimation = TableViewAnimation.Cell.fade(duration: 0.5)
                self.tableListView.animate(animation: myCoolTableAnimation)
                MUDBManager.sharedInstance.savePeople(people: self.peopleData)
                refreshControl.endRefreshing()
            }
         }
    }
    
    // MARK: laodOfflineData

    func laodOfflineData() // ** Load Offline
    {
          MUDBManager.sharedInstance.getPeople { (data) in
            DispatchQueue.main.async {
                self.peopleData = data
                self.tableListView.reloadData()
                let myCoolTableAnimation = TableViewAnimation.Cell.fade(duration: 0.5)
                self.tableListView.animate(animation: myCoolTableAnimation)
                self.refreshControl.endRefreshing()
            }
        }
    }

}


extension ViewController : UITableViewDelegate {
  
    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier)! as! MainTableViewCell
        let person = self.peopleData[indexPath.section]
        cell.loadCellData(person: person)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showPersonDetails()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showPersonDetails () {
        //** Navigate to details screeen.
        let index = self.tableListView.indexPathForSelectedRow
        let indexNumber = index?.section
        let personSelected = self.peopleData[indexNumber!]
        let detailVc = MUPersonDetailsController()
        detailVc.selectedPersonData = personSelected
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}

extension ViewController : UITableViewDataSource {
    
    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.peopleData != nil) {
            return self.peopleData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return headerFooterHeight
         }
        return 20
     }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.peopleData.count - 1 {  return headerFooterHeight }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = UILabel()
            header.frame = CGRect(x: 25, y: 10, width: tableView.frame.size.width - 20, height: 25)
            header.text = "People"
            header.font = UIFont.boldSystemFont(ofSize: 18)
            let headerView = UIView()
            headerView.addSubview(header)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == self.peopleData.count - 1 {
            let footer = UILabel()
            footer.frame = CGRect(x: 25, y: 10, width: tableView.frame.size.width - 20, height: 25)
            footer.text = "Coding Assignment by - Viswa Bharath Dakka."
            footer.font = UIFont.systemFont(ofSize: 12)
            footer.textColor = UIColor.gray
            let footerView = UIView()
            footerView.addSubview(footer)
            return footerView
        }
        return nil
    }

}

final class MainTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = String(describing: MainTableViewCell.self)
    fileprivate var originalWidth: CGFloat?
    
    // MARK: Initialize
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default
        maskToBounds = false
        cornerRadius = 8
        backgroundColor = UIColor.white
        textLabel?.numberOfLines = 0
        textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        detailTextLabel?.textColor = UIColor.gray
        accessoryView = UIImageView(image: UIImage(named: "Cell Disclosure"))
        let view = UIView()
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 243/255, alpha: 1)
        selectedBackgroundView = view
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // Set the width of the cell
        if originalWidth == nil {
            originalWidth = size.width
        }
        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: (originalWidth ?? size.width) - 40, height: bounds.size.height)
        super.layoutSubviews()
    }
    
    override var bounds: CGRect {
        didSet {
            shadowColor = .black
            shadowOffset = CGSize(width: 2, height: 4)
            shadowRadius = 8
            shadowOpacity = 0.2
            shadowPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
            shadowShouldRasterize = true
            shadowRasterizationScale = UIScreen.main.scale
        }
    }
    
    func loadCellData(person:MUPersonData) {
        self.textLabel?.text = person.name
        self.detailTextLabel?.text = person.email
        self.imageView?.sd_setImage(with: URL(string: person.picture!) , placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.highPriority, completed: nil)
    }
}
