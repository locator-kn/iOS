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
        let env = NSProcessInfo.processInfo().environment
        if let token: String = env["mixpanel"] {
            print(token)
            mixpanel = Mixpanel.sharedInstanceWithToken(token)
        }
    }
    
    func trackEvent(event: String) {
         mixpanel.track(event);
    }
    
    func setIdentity(id: String, name: String, mail: String) {
        mixpanel.identify(id);
        mixpanel.people.set(["$email": mail, "$name": name]);
    }
    
}
