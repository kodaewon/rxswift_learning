//
//  ImageViewController.swift
//  RxSwift-Learning
//
//  Created by 고대원 on 2019/12/16.
//  Copyright © 2019 kodeawon. All rights reserved.
//

import UIKit

import RxSwift

class ImageViewController: UIViewController {
    
    @IBOutlet weak var loadImageView: UIImageView!
    @IBOutlet weak var countingLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var count: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "LoadImage"

        loadImageView.contentMode = .scaleToFill
        loadImageView.backgroundColor = .gray
        
        countingLabel.text = "\(count)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
        print("viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
    }

    //MARK: Actions
    @IBAction func loadDidTap(_ sender: UIButton) {
        self.loadImageView.image = nil
        count = 0
        countingLabel.text = "\(count)"
        
        rxswiftCounting()
        
        rxswiftLoadImage(from: LARGEST_IMAGE_URL)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (image) in
                self.loadImageView.image = image
                self.disposeBag = DisposeBag()
            }, onError: { (err) in
                print("\(#function) error \(err)")
            }, onCompleted: {
                print("\(#function) onCompleted")
            }) {
                print("\(#function) dispose")
        }.disposed(by: disposeBag)
    }
    
    @IBAction func cancelDidTap(_ sender: UIButton) {
        disposeBag = DisposeBag()
    }
}

//MARK: - RxSwift
extension ImageViewController {
    func rxswiftLoadImage(from imageURL: String) -> Observable<UIImage?> {
        return Observable.create { seal in
            asyncLoadImage(from: imageURL) { (image) in
                seal.onNext(image)
                seal.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func rxswiftCounting() {
        Observable<Int>.interval((.milliseconds(1 * 100)), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (count) in
                self.count += 1
                self.countingLabel.text = "\(count)"
            },onError: { (err) in
                print("\(#function) error \(err)")
            }, onCompleted: {
                print("\(#function) onCompleted")
            }) {
                print("\(#function) dispose")
            }.disposed(by: disposeBag)
    }
}
