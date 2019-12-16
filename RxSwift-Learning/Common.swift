//
//  Common.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/16.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import UIKit

let LARGE_IMAGE_URL = "https://picsum.photos/1024/768/?random"
let LARGER_IMAGE_URL = "https://picsum.photos/1280/720/?random"
let LARGEST_IMAGE_URL = "https://picsum.photos/2560/1440/?random"

//MARK: - Image Load Request
func syncLoadImage(from imageURL: String) -> UIImage? {
    guard let url = URL(string: imageURL) else { return nil }
    guard let data = try? Data(contentsOf: url) else { return nil }
    
    let image = UIImage(data: data)
    return image
}

func asyncLoadImage(from imageURL: String, completed: @escaping ((UIImage?) -> Void)) {
    DispatchQueue.global().async {
        completed(syncLoadImage(from: imageURL))
    }
}
