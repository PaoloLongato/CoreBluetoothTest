//
//  ConnectionManager.swift
//  CoreBluetoothTest
//
//  Created by Paolo Longato on 25/06/2016.
//  Copyright © 2016 Paolo Longato. All rights reserved.
//

import Foundation

final class ConnectionManager {
    
    private var bluetoothManager: BluetoothManager?
    private var novipelFrameMake: ((NSData) -> NovipelFrame)?
    
    func connect(listener listener: ((NovipelFrame)->())) {
        self.bluetoothManager = BluetoothManager()
        self.novipelFrameMake = bleFrameMake
        self.bluetoothManager?.onUpdate = { [weak self] (data) in
            guard self != nil else { return }
            listener(self!.novipelFrameMake!(data))
        }
    }
    
    func disconnect() {
        self.bluetoothManager?.stopScanning()
    }
    
}

// Mark: Frame making functions

func bleFrameMake(data data: NSData) -> NovipelFrame {
    return NovipelFrame(frontArray: [10,10], backArray: [10,10], leftArray: [10,10], rightArray: [10,10])
}