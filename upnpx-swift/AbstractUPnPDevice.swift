//
//  BasicUPnPDevice.swift
//  ControlPointDemo
//
//  Created by David Robles on 11/17/14.
//  Copyright (c) 2014 David Robles. All rights reserved.
//

import Foundation

class AbstractUPnPDevice_Swift: AbstractUPnP_Swift {
    struct IconDescription: Printable {
        let relativeURL: NSURL
        let width, height, depth: Int
        let mimeType: String
        var description: String {
            return "\(relativeURL.absoluteString!) (\(mimeType):\(width)x\(height))"
        }
    }
    
    // public
    let udn: String!
    let baseURL: NSURL!
    let friendlyName: String!
    let manufacturer: String!
    let manufacturerURL: NSURL?
    let modelDescription: String?
    let modelName: String!
    let modelNumber: String?
    let modelURL: NSURL?
    let serialNumber: String?
    let iconDescriptions: [IconDescription]?
    override var className: String { return "AbstractUPnPDevice_Swift" }
    override var description: String {
        var properties = [String: String]()
        properties[super.className] = super.description.stringByReplacingOccurrencesOfString("\n", replacement: "\n\t")
        
        if let udn = udn { properties["udn"] = udn }
        if let absoluteBaseURL = baseURL.absoluteString { properties["baseURL"] = absoluteBaseURL }
        if let friendlyName = friendlyName { properties["friendlyName"] = friendlyName }
        if let manufacturer = manufacturer { properties["manufacturer"] = manufacturer }
        if let absoluteManufacturerURL = manufacturerURL?.absoluteString { properties["manufacturerURL"] = absoluteManufacturerURL }
        if let modelDescription = modelDescription { properties["modelDescription"] = modelDescription }
        if let modelName = modelName { properties["modelName"] = modelName }
        if let modelNumber = modelNumber { properties["modelNumber"] = modelNumber }
        if let absoluteModelURL = modelURL?.absoluteString { properties["modelURL"] = absoluteModelURL }
        if let serialNumber = serialNumber { properties["serialNumber"] = serialNumber }
        if let iconDescriptions = iconDescriptions { properties["iconDescriptions"] = arrayDescription(iconDescriptions).stringByReplacingOccurrencesOfString("\n", replacement: "\n\t") }

        return stringDictionaryDescription(properties)
    }
    
    override init?(ssdpDevice: SSDPDBDevice_ObjC) {
        super.init(ssdpDevice: ssdpDevice)
        
        let deviceParser = UPnPDeviceParser_Swift(upnpDevice: self)
        let parsedDevice = deviceParser.parse().parsedDevice
        
        if let udn = returnIfContainsElements(parsedDevice?.udn) {
            self.udn = udn
        }
        else { return nil }
        
        if let baseURL = parsedDevice?.baseURL {
            self.baseURL = baseURL
        }
        else {
            self.baseURL = NSURL(string: "/", relativeToURL: self.xmlLocation)?.absoluteURL
        }
        
        if let friendlyName = returnIfContainsElements(parsedDevice?.friendlyName) {
            self.friendlyName = friendlyName
        }
        else { return nil }
        
        if let manufacturer = returnIfContainsElements(parsedDevice?.manufacturer) {
            self.manufacturer = manufacturer
        }
        else { return nil }
        
        self.manufacturerURL = parsedDevice?.manufacturerURL
        self.modelDescription = parsedDevice?.modelDescription
        
        if let modelName = returnIfContainsElements(parsedDevice?.modelName) {
            self.modelName = modelName
        }
        else { return nil }
        
        self.modelNumber = parsedDevice?.modelNumber
        self.modelURL = parsedDevice?.modelURL
        self.serialNumber = parsedDevice?.serialNumber
        self.iconDescriptions = parsedDevice?.iconDescriptions
    }
}