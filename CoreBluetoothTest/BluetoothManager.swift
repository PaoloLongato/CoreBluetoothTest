//
//  BluetoothManager.swift
//  CoreBluetoothTest
//
//  Created by Paolo Longato on 16/04/2016.
//  Copyright © 2016 Paolo Longato. All rights reserved.
//
/*
MOTIVATION
CoreBluetooth framework manages BLE hardware connection and scanning via the usual protocol-delegate pattern.  Use the more expressive callback pattern and "facade APIs" for managing Buetooth device scanning and connection is an enticing idea when programming in Swift. I would expect code to be more radable, less fragmented in different places and shorter.  The challenge is: will it be reusable? Code that handles hardware SHOULD be aim for maximum reusability, as hardware changes extremely slowly with time; I would therefore expect Cocoa Touch classes that handle BLE connectivity to evolve extremely slowly with time.
 
STATE OF THE PROJECT
Sourcing some BLE hardware that can be used as a test case for connectivity.
 
NOTES
- The bluetooth manager will start scanning all peripherals as soon as the hardware is ready and the app authorized to scan.  This happens immediately upon initialization.
- Scanning all BLE peripherals is not good practice but can be useful => initialize the object with optional BLE services (e.g. and array of CBService objects).  In this way you can acheive both behaviours: scann all BLE devices OR only the ones with specified service(s) (as recommended by Apple).
- Scanning as soon as the class is initialized MIGHT be a restrictive behaviour. On the other hand, calling a "refresh" immediately after the class has been created will not do anything because the OS has not yet finished to check the hardware state and permissions (synchronous vs. async behaviour) => the listener should not ONLY listen for the list of peripherals but ALSO for permission changes: it would be up to the user make good use of the BLE state information. Most likely a real world application will need to warn the user that there is something wrong with the bluetooth (e.g. it's OFF), but we cannot force this level of complexiity onto any user without knowing exactly how the class is used.
- Abstracting BLE hardware states into simpler ones does not seem very reusable.  AVOID!
- This class should be restricted to scanning and connecting to a peripheral while peripheral interaction (after connection) should be handled by a separate class => conforming to CBPeripheralDelegate is redundant. This further class would be heavily dependent on the specific hardware we are dealing with, with the connection and scanning (this class) should be kept reusable.
- It would also be a good idea to wrap CBPeripheral inside an "adapter" object ("Peripheral"?) so that RSSI at time of scan and advertisement packets are easily accessed inside the application.  It is data that otherwise would be lost.
*/

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private let centralManager = CBCentralManager()
    var listener: (([CBPeripheral]) -> ())?
    var onUpdate: ((NSData) -> ())?
    var peripherals = Set<CBPeripheral>() {
        didSet(newPeripherals) {
            guard (listener != nil) else { return }
            listener!(Array(newPeripherals))
        }
    }
    var output: String = ""
    var counter: Int = 0
    
    // Designated initializer
    override init() {
        super.init()
        centralManager.delegate = self
    }
    
    // Methods
    func refresh() {
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    // Mark: central manager delegate methods
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        peripherals.insert(peripheral)
        if peripheral.name == "CC41-A" {
            centralManager.connectPeripheral(peripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Novipel Probe Connected Captain.")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    // Mark: peripheral delegate methods
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("SERVICES = \(peripheral.services)")
        if let service = peripheral.services?.first {
            let service2 = peripheral.services![1]
            peripheral.discoverCharacteristics(nil, forService: service2)
        }
        
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("SERVICE \(service.UUID) with CHARACTERISTICS = \(service.characteristics)")
        if service.UUID == CBUUID(string: "FFE0") {
            if let characteristic = service.characteristics?.filter({ $0.UUID.UUIDString == "FFE1" }).first {
                print("READING CHARACTERISTC = \(characteristic.UUID.UUIDString)")
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if characteristic.UUID.UUIDString == "FFE1" {
            // Call
            if let dataString = NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding) {
                debugPrint("\(NSDate().timeIntervalSinceReferenceDate * 1000), \(dataString)")
                //print("+") // reception testing
                // STRING OF DATA
                // output.appendContentsOf("\(NSDate().timeIntervalSinceReferenceDate * 1000), \(dataString)"+"\n")
                // counter += 1
                //print("\(counter)")
                //if counter == 50 { print(output) }
            }
            // Call onUpdate
            if let value = characteristic.value {
                guard self.onUpdate != nil else { return }
                self.onUpdate!(value)
            }
        }
    }
    
    // BLE Hardware state
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state {
        case .Unknown:
            print("unknown")
        case .Resetting:
            print("resetting")
        case .Unsupported:
            print("unsupported")
        case .Unauthorized:
            print("unauthorized")
        case .PoweredOff:
            print("off")
            peripherals.removeAll()
        case .PoweredOn:
            print("on")
            centralManager.scanForPeripheralsWithServices(nil, options: nil)
        default:
            print("nothing")
        }
        
    }
    
    func stopScanning() {
        self.centralManager.stopScan()
    }
    
    // Mark: Peripheral delegate methods
}
