//
//  PlaceModel.swift
//  Rate Places
//
//  Created by Nadzieja on 22/09/2019.
//  Copyright © 2019 Nadzieja Siwucha. All rights reserved.
//

import UIKit

struct Place {
    
    var name: String      // это св-во будет обязательным, остальные все нет (опциональные)
    var position: String?
    var type: String?
    var photo: UIImage? // будем им пользоваться только при добавлении этого фото от пользователя
    var baseImage: String? // обращаемся к нему по имени, поэтому String
    
    //    let placeName = [
    //                    "Vegano", "Zielona Kuchnia", "Garden Restaurant", "Pod Złotym Karpiem", "Youmiko Sushi"
    //
    //   ]

}
