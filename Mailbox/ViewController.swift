//
//  ViewController.swift
//  Mailbox
//
//  Created by Manpreet Singh on 10/2/15.
//  Copyright © 2015 Bootcamp Hw#3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var mainView: UIView!

    @IBOutlet weak var searchView: UIImageView!
    @IBOutlet weak var swipeMenu: UIImageView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var helpView: UIImageView!
    @IBOutlet weak var singleMessageView: UIView!
    
    @IBOutlet weak var singleMessage: UIImageView!
    
    @IBOutlet weak var deleteIcon: UIImageView!
    
    @IBOutlet weak var archiveIcon: UIImageView!
    
    @IBOutlet weak var laterIcon: UIImageView!
    
    @IBOutlet weak var listIcon: UIImageView!
    
    @IBOutlet weak var laterView: UIImageView!
    
    @IBOutlet weak var listView: UIImageView!
    var sidePan : CGPoint!
      var original : CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       scrollView.contentSize = feedImage.frame.size
        print (feedImage.frame.size)
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "sidePanning:")
        edgeGesture.edges = UIRectEdge.Left
        mainView.addGestureRecognizer(edgeGesture)
        print (singleMessage.frame.origin.x)
        
        print (singleMessage.frame.origin.y)
        print("Hereeeeeeccccc")
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
        
    }
    
    @IBAction func tapfeedView(sender: UITapGestureRecognizer) {
        bringbackView()
    }
    
    @IBAction func onTapLaterView(sender: UITapGestureRecognizer) {
        print("tap")
        
        UIView.animateWithDuration(0.2) { () -> Void in
           self.listView.alpha = 0
            self.laterView.alpha = 0
            
        }
        
        
    }

    func swipeLeft() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.singleMessage.center.x = -320-180-30-(25/2)
            self.listIcon.center.x = -320-30
            self.laterIcon.center.x = -320-30
            }, completion: nil)
    }
    
    func swipeRight() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.singleMessage.center.x = 320+180+30+(25/2)
            self.archiveIcon.center.x = 320+30
            self.deleteIcon.center.x = 320+30
            }, completion: nil)
    }
    
    func convertValue(value: Float, r1Min: Float, r1Max: Float, r2Min: Float, r2Max: Float) -> Float {
        let ratio = (r2Max - r2Min) / (r1Max - r1Min)
        return value * ratio + r2Min - r1Min * ratio
    }
    
    func updateScrollView() {
    
        UIView.animateWithDuration(0.2,delay: 0.5, options: [], animations: { () -> Void in
            //self.scrollView.contentSize = CGSize(width: 320, height: self.searchView.image!.size.height + self.helpView.image!.size.height + self.feedImage.image!.size.height)
            self.feedImage.center.y -= self.singleMessage.image!.size.height
            }, completion: nil)
    }
    
    func bringbackView() {
        
        self.feedImage.center.y += self.singleMessage.image!.size.height
        self.singleMessage.frame.origin.x = 0.0
        self.singleMessage.frame.origin.y = -5.0
        
    }
    
    @IBAction func messageViewPan(sender: UIPanGestureRecognizer) {
        _ = sender.locationInView(view)
        let translation = sender.translationInView(view)
        _ = sender.translationInView(view)
        
        
        if sender.state == UIGestureRecognizerState.Began {
        
            
             original = singleMessage.center
            
        }

        else if sender.state == UIGestureRecognizerState.Changed
        {
            singleMessage.center.x = translation.x + original.x
            
            archiveIcon.alpha = 0
            deleteIcon.alpha = 0
            listIcon.alpha = 0
            laterIcon.alpha = 0
            
            
            // List (brown)
            if translation.x < -260 {
                singleMessageView.backgroundColor = UIColor.brownColor()
                laterIcon.alpha = 1
                laterIcon.center.x = translation.x + 350
                
                // Later (yellow)
            } else if translation.x < -60 {
                singleMessageView.backgroundColor = UIColor.yellowColor()
                listIcon.alpha = 1
                listIcon.center.x = translation.x + 350
                
                // Later (not active)
            } else if (translation.x < 0 && translation.x > -60) {
                singleMessageView.backgroundColor = UIColor.grayColor()
                let listIconAlpha = convertValue(Float(translation.x), r1Min: 0, r1Max: -60, r2Min: 0, r2Max: 1)
                listIcon.alpha = CGFloat(listIconAlpha)
                listIcon.center.x = 290
                
                // Archive (not active)
            } else if (translation.x > 0 &&  translation.x < 60) {
                singleMessageView.backgroundColor = UIColor.grayColor()
                let archiveIconAlpha = convertValue(Float(translation.x), r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
                archiveIcon.alpha = CGFloat(archiveIconAlpha)
                archiveIcon.center.x = 30
                
                
                // Archive (green)
            } else if (translation.x) < 260 {
                singleMessageView.backgroundColor = UIColor.greenColor()
                archiveIcon.alpha = 1
                archiveIcon.center.x = translation.x - 30
                
                // Trash (red)
            } else if (translation.x) > 260 {
                singleMessageView.backgroundColor = UIColor.redColor()
                archiveIcon.alpha = 0
                deleteIcon.alpha = 1
                deleteIcon.center.x = translation.x - 30
            }
        
    }
        
        else if sender.state == UIGestureRecognizerState.Ended {
            print(translation.x)
            // List (brown)
            if translation.x < -260 {
                self.swipeLeft()
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.listView.alpha = 1
                    }, completion: nil)
                
                // Later (yellow)
            } else if translation.x < -60 && translation.x > -260 {
                self.swipeLeft()
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.laterView.alpha = 1
                    self.updateScrollView()
                    }, completion: nil)
                
                // Reset
            } else if translation.x > -60 && translation.x < 60 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.singleMessage.center.x = 160
                    }, completion: nil)
                
                // Archive
            } else if translation.x > 60 && translation.x < 260 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.swipeRight()
                    self.updateScrollView()
                    
                    }, completion: nil)
                
                
                // Trash
            } else if translation.x > 260 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.swipeRight()
                    self.updateScrollView()
                    }, completion: nil)
            }
            
            
        }
    
    }
    
   
  @IBAction  func sidePanning(sender: UIScreenEdgePanGestureRecognizer) {
        
        print("Hereeeeee")
        let translation = sender.translationInView(view)
        print(translation)
        
        if (sender.state == UIGestureRecognizerState.Began)
        {
            sidePan = swipeMenu.center
        
            print("Began")
        }
        
        else if (sender.state == UIGestureRecognizerState.Changed)
        {
            
            print("Changed")
            
            swipeMenu.center.x = sidePan.x + translation.x
            
            
        }
        
        else if (sender.state == UIGestureRecognizerState.Ended)
        {
            
            print("Ended")
            
            //swipeMenu.center.x = sidePan.x + translation.x
            
            UIView.animateWithDuration(
               0.5, animations: { () -> Void in
                    self.swipeMenu.center.x = self.mainView.center.x
                    
                }, completion: { (COMPLETED) -> Void in
                
                    UIView.animateWithDuration(1, animations: { () -> Void in
                        self.swipeMenu.center.x = self.swipeMenu.center.x + self.sidePan.x - translation.x
                    })
                    
                    
                
            })
            
            
        }
        
    }
    


}
