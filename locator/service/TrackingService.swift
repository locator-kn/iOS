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
    var mixpanel: Mixpanel?
    
    init() {
        mixpanel = Mixpanel.sharedInstanceWithToken("39259b14d0685a26d043c2f394718d4b")
    }
    
    func trackEvent(event: String) {
        if let mix = mixpanel {
            mix.track(event);
        }
    }
    
    func setIdentity(id: String, name: String, mail: String) {
        if let mix = mixpanel {
            mix.identify(id);
            mix.people.set(["$email": mail, "$name": name]);
        }
    }
    
}
