//
//  RealmIngredientModel.swift
//  Glass Bottle
//
//  Created by Saransh Duggal on 2022-04-27.
//

import Foundation
import RealmSwift

//MARK: Realm Object for an Ingredient in Database

class Ingredient: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var isHarmful: Bool = false

    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
