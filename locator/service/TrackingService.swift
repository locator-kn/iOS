//
//  TrackingService.swift
//  locator
//
//  Created by Michael Knoch on 12/04/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import Foundation
import Mixpanel

class TrackingService {
    
    static var sharedInstance = TrackingService()
    var mixpanel: Mixpanel!
    
    init() {
        mixpanel = Mixpanel.sharedInstanceWithToken("8a116f252618b432ac6eaaee50374a69fee1b689a0fc7b750c7e9eca80caf141")
    }
    
    func trackEvent(event: String) {
         mixpanel.track(event);
    }
    
    func setIdentity(id: String, name: String, mail: String) {
        mixpanel.identify(id);
        mixpanel.people.set(["$email": mail, "$name": name]);
    }
    
}
