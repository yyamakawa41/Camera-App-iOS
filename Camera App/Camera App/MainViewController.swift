//
//  MainViewController.swift
//  Camera App
//
//  Created by Yohsuke Yamakawa on 12/2/15.
//  Copyright © 2015 DigitalCrafts. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    override func viewDidLoad() {
        self.imageStore = [UIImage]()
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: "zoomImage")
        gesture.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(gesture)
        self.scrollView.delegate = self
        previewCollectionView.alpha = 0.0
        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let image = self.imageStore[indexPath.item]
        self.displayImageView.image = image
    }
    
    private var imageStore : [UIImage]!
    private var currentZoom : CGFloat = 1.0
    
    func zoomImage(){
        if self.currentZoom == 1.0 {
        self.currentZoom = 2.0
    }
        else {
        self.currentZoom = 1.0
        }
        UIView.animateWithDuration(0.5) { [unowned self] in
        self.scrollView.minimumZoomScale = self.currentZoom
        self.scrollView.maximumZoomScale = self.currentZoom
        self.scrollView.zoomScale = self.currentZoom
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.displayImageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView (collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let image = self.imageStore[indexPath.row]
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PreviewCellReuseID", forIndexPath: indexPath)as? PreviewCollectionViewCell{
            cell.previewImageView.image = image
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int { return self.imageStore.count
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FilterSegue" {
            if let vc : FilterViewController =
            segue.destinationViewController as? FilterViewController {
            vc.sourceImage = self.displayImageView.image
            }
        }
    }



    @IBOutlet weak var previewCollectionView: UICollectionView!
    @IBAction func actionButtonTouched(sender: AnyObject) {if let image = self.displayImageView.image {
        //Add code here
        let activityViewController =
        UIActivityViewController(activityItems: [image],
            applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeMail]
        self.presentViewController(activityViewController, animated: true,
            completion:nil)
        }
        
    }
    @IBAction func cameraButtonTouched(sender: UIBarButtonItem){
       self.displayImagePicker(.Camera)
    }
    @IBAction func libraryButtonTouched(sender: UIBarButtonItem) {
        self.displayImagePicker(.PhotoLibrary)
    }
    
    @IBAction func didSelectFilter(segue: UIStoryboardSegue) {
        if segue.identifier == "FilterSelectedSegue" {
        if let source = segue.sourceViewController as?
        FilterViewController,
        let image = source.filteredImage {
        self.displayImageView.image = image
        }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var displayImageView: UIImageView!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage,
        editingInfo: [String : AnyObject]?) {
        self.displayImageView.image = image
        self.imageStore.insert(image, atIndex: 0)
        self.previewCollectionView.reloadData()
        previewCollectionView.alpha = 1.0
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayImagePicker(sType:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sType
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
}
