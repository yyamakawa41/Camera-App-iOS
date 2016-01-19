//
//  FilterViewController.swift
//  Camera App
//
//  Created by Yohsuke Yamakawa on 1/18/16.
//  Copyright © 2016 DigitalCrafts. All rights reserved.
//

import UIKit
class FilterViewController : UIViewController, UITableViewDataSource {
    
    var filteredImage: UIImage?
    private var sourcePrefix : String?
    private var filters : [(filterName: String, path: String)] =
    [(filterName: String, path: String)]()
    private let filterManager : ImageFilterManager =
    ImageFilterManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var sourceImage : UIImage?{
        didSet {
        self.sourcePrefix = NSUUID().UUIDString
        filterManager.createFiltersForImage(self.sourceImage!,
        filePrefix: self.sourcePrefix!) { (filters) -> Void in
        self.filters = filters
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
        }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return self.filters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell =
        self.tableView.dequeueReusableCellWithIdentifier("filterReuseID",
        forIndexPath: indexPath) as? FilterTableViewCell else {
        return UITableViewCell()
        }
        let filter = self.filters[indexPath.item]
        cell.filterImageView.image = UIImage(contentsOfFile:
        filter.path)
        cell.filterNameLabel.text = filter.filterName
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FilterSelectedSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow
        {
            let filter = self.filters[indexPath.item]
            self.filteredImage = UIImage(contentsOfFile:
            filter.path)
            }
        }
    }
    
}