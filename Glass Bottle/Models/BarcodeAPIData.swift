//
//  BarcodeAPIModel.swift
//  Glass Bottle
//
//  Created by Saransh Duggal on 2022-04-25.
//

import UIKit

//MARK: Barcode JSON models
    struct BarcodeAPIResult: Codable {
        let items: [BarcodeAPIJSON]
        let code: String
    }

    struct BarcodeAPIJSON: Codable {
        let title: String
        let brand: String
    }
