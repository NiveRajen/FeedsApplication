//
//  Reachability.swift
//  FeedApp
//
//  Created by Nivedha Rajedran on 12/05/21.
//

import Foundation
import Network

//MARK: - NETWORKCHECKOBSERVER
protocol NetworkCheckObserver: AnyObject {
  func statusDidChange(status: NWPath.Status)
}

class NetworkCheck {
  
  struct NetworkChangeObservation {
    weak var observer: NetworkCheckObserver?
  }
  
  private var monitor = NWPathMonitor()
  private static let _sharedInstance = NetworkCheck()
  private var observations = [ObjectIdentifier: NetworkChangeObservation]()
  static var sharedInstance = NetworkCheck()
  
  //getting the current status from nwpath
  var currentStatus: NWPath.Status {
    get {
      return monitor.currentPath.status
    }
  }
  
  
  private init() {
    monitor.pathUpdateHandler = { [unowned self] path in
      for (id, observations) in self.observations {
        
        //If any observer is nil, remove it from the list of observers
        guard let observer = observations.observer else {
          self.observations.removeValue(forKey: id)
          continue
        }
        
        DispatchQueue.main.async(execute: {
          observer.statusDidChange(status: path.status)
        })
      }
    }
    monitor.start(queue: DispatchQueue.global(qos: .background))
  }
  
  
  func addObserver(observer: NetworkCheckObserver) {
    let id = ObjectIdentifier(observer)
    observations[id] = NetworkChangeObservation(observer: observer)
  }
  
  
  func removeObserver(observer: NetworkCheckObserver) {
    let id = ObjectIdentifier(observer)
    observations.removeValue(forKey: id)
  }
  
}
