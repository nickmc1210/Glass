//
//  ViewController.swift
//  Glass
//
//  Created by Nick McCardel on 1/16/15.
//  Copyright (c) 2015 Nicholas McCardel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var destroyTime: NSTimeInterval = 1.5
    
    var touchData: [NSTimeInterval: NSValue] = [:]
    
    var touchDate: NSDate!
    
    var persist = false
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var persistButton: UIButton!
    
    override func viewDidLoad() {
        //
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        //
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearButtonPressed() {
        //
        let subviews = self.view.subviews
        for view in subviews {
            if view as? UIButton != self.clearButton && view as? UIButton != self.persistButton {
                view.removeFromSuperview()
            } else {
                println("button pressed")
            }
        }
    }

    @IBAction func persistButtonPressed() {
        //
        if self.persist == false {
            self.persist = true
            self.persistButton.titleLabel?.textColor = UIColor.redColor()
            self.persistButton.backgroundColor = UIColor.grayColor()
        } else {
            self.persist = false
            self.persistButton.titleLabel?.textColor = UIColor.whiteColor()
            self.persistButton.backgroundColor = UIColor.blackColor()
        }
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //
        for touch in touches {
            let touch = touch as UITouch
            self.touchDate = NSDate()
            addTouchData(touch)
            println("touch")
            addCircleAtTouchWithTimedDestruction(touch, radius: 5, time: self.destroyTime)
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        //
        for touch in touches {
            let touch = touch as UITouch
            addTouchData(touch)
            addCircleAtTouchWithTimedDestruction(touch, radius: 5, time: self.destroyTime)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        //
        println("total Touch Data: \(self.touchData)\n")
        self.touchData.removeAll(keepCapacity: false)
    }
    
    func addCircleAtTouchWithTimedDestruction(touch: UITouch, radius: CGFloat, time: NSTimeInterval) {
        //
        let location = touch.locationInView(self.view)
        let circle = makeCircle(location, radius: radius)
        if persist == false {
            let timer = NSTimer.scheduledTimerWithTimeInterval(time, target: circle, selector: "removeFromSuperview", userInfo: nil, repeats: false)
        }
        self.view.addSubview(circle)
    }
    
    func makeCircle(location: CGPoint, radius: CGFloat) -> UIView {
        //
        var circleView = UIView(frame: CGRectMake(location.x, location.y, radius * 2, radius * 2))
        circleView.alpha = 0.75
        circleView.backgroundColor = UIColor.whiteColor()
        circleView.layer.cornerRadius = radius
        
        return circleView
    }
    
    func addTouchData(touch: UITouch) {
        //
        println("add touch data invoked")
        let location = touch.locationInView(self.view)
        let value = NSValue(CGPoint: location)
        let interval = self.touchDate.timeIntervalSinceNow
        println("location: \(location)")
        println("interval: \(interval)")
        self.touchData.updateValue(value, forKey: interval)
    }
}

