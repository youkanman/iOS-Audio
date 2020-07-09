//
//  ViewController.swift
//  iOS-AudioTest
//
//  Created by  on 2020/07/08.
//  Copyright © 2020 youkan. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonAudio: UIButton!
    @IBOutlet weak var labelGain: UILabel!
    @IBOutlet weak var sliderGain: UISlider!
    
    var sliderValue: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sliderGain.value = Float(sliderValue)
        labelGain.text = String(sliderValue)
    }

    @IBAction func displayMessage(_ sender: Any) {
        label.text = "Hello World."
    }
    
    //@IBAction func gainValue(_ sender: Any) {
    //    let sliderValue:Int = Int(sender.value)
    //    labelGain.text = String(sliderValue)
    //}
    
    @IBAction func gainValue(_ sender: UISlider, forEvent event: UIEvent) {
        sliderValue = Int(sender.value)
        labelGain.text = String(sliderValue)
    }

    @IBAction func playAudio(_ sender: Any) {
        label.text = "Play Audio."
     
        do {
            var file = try AKAudioFile(readFileName: "output02.wav")
            var player = try AKAudioPlayer(file: file)
            // Define your gain below. >1 means amplifying it to be louder
            //let booster = AKBooster(player, gain: 1.3)
            var booster = AKBooster(player, gain: Double(sliderGain.value))
            AudioKit.output = booster
            try AudioKit.start()
            // And then to play your file:
            player.play()

            label.text = "Stop Audio."
        } catch {
            // Log your error
        }
    }
}


