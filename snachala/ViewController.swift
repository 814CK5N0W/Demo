//
//  ViewController.swift
//  Swinject
//
//  Created by blacksnow on 5/3/23.
//

import UIKit
import Swinject


class ColorProvider: ColorProviding {
    var color: UIColor {
        let colors: [UIColor] = [.systemPink, .systemBlue, .systemRed]
        return colors.randomElement()!
    }
}


class ViewController: UIViewController {

    let container: Container = {
        let container = Container()
        container.register(ColorProviding.self) { _ in
            return ColorProvider()
        }
        container.register(SecondVC.self) { resolver in
            let vc = SecondVC(provider: resolver.resolve(ColorProviding.self))
            return vc
        }
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: CGRect(x: 0,y: 0, width: 200, height: 50))
        button.setTitle("HAIIIMU", for: .normal)
        button.center = view.center
        button.addTarget(self, action: #selector(handleButton), for:
                .touchUpInside
        )
        button.setTitleColor(.red, for: .normal)
        view.addSubview(button)
        // Do any additional setup after loading the view.
    }
    @objc private func handleButton() {
        print("TAPPED")
        guard let vc = container.resolve(SecondVC.self) else { return }
        present(vc, animated: true)
        
        
    }

}


protocol ColorProviding {
    var color: UIColor { get }
}

class SecondVC: UIViewController {
    
    private let provider: ColorProviding?
    
    init(provider: ColorProviding?) {
        self.provider = provider!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = provider?.color ?? .black
    }
    
}


