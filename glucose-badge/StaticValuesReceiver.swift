//
//  StaticValuesReceiver.swift
//  glucose-badge
//
//  Created by Dennis Gove on 1/18/16.
//  Copyright © 2016 gove. All rights reserved.
//

import Foundation

// Implements a receiver which will iterate through a list of static
// values at some fixed rate. This can be used for testing purposes.
//
// TODO: Move this into a standard swift testing set

class StaticValuesReceiver : Receiver {

    private var notifier: ReceiverNotificationDelegate?
    private var readings: [Reading]?
    private var valueChangeInterval: Double
    private var valueSender: NSTimer?
    private var nextValueIdx: Int

    internal init(readings: [Reading]?, valueChangeInterval: Double) {
        self.readings = readings
        self.valueChangeInterval = valueChangeInterval
        self.nextValueIdx = 0
    }

    // Begin sending values through the notifier
    // Returns false if no values exist to send or notifier is null
    func connect() -> Bool {
        if(nil == self.notifier || nil == self.readings || 0 == self.readings?.count){
            return false
        }

        if(nil == valueSender){
            valueSender = NSTimer.scheduledTimerWithTimeInterval(valueChangeInterval, target: self, selector: "sendNextValue", userInfo: nil, repeats: true)
        }
        return true
    }

    // Stop sending values through the notifier
    // Always returns true
    func disconnect() -> Bool {
        if(nil != valueSender){
            valueSender?.invalidate()
            valueSender = nil
        }
        return true
    }

    var readingNotifier: ReceiverNotificationDelegate? {
        get{ return self.notifier }
        set{ self.notifier = newValue }
    }

    private func sendNextValue() {
        if(nil != notifier && nil != readings){
            notifier?.receiver(self, didReceiveReading: readings![nextValueIdx])
            nextValueIdx = (nextValueIdx + 1) % readings!.count
        }
    }

}