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
    @IBOutlet weak var buttonAudio: UIButton!
    @IBOutlet weak var labelGain: UILabel!
    @IBOutlet weak var sliderGain: UISlider!
    
    var sliderValue: Int = 0
    
    let wavList = ["output02.wav", "output00.wav", "output01.wav"]
    //let wavList = ["output02.wav"]

    // Audioの再生
    var players = [AKAudioPlayer]()
    var currentPlayer: AKAudioPlayer?
    var currentPlayerIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sliderGain.value = Float(sliderValue)
        labelGain.text = String(sliderValue)

        // create audio player
        players = getPlayers()
    }

    @IBAction func gainValue(_ sender: UISlider, forEvent event: UIEvent) {
        sliderValue = Int(sender.value)
        labelGain.text = String(sliderValue)
    }

    @IBAction func playAudio(_ sender: Any) {
        
        if currentPlayer?.isPlaying ?? false {
            print("Playing...")
            return
        }

        // 1セット目再生
        buttonAudio.isEnabled = false
        playAudio()
    }
    
    private func playAudio() {
        currentPlayer = players[currentPlayerIndex]
        
        do {
            // Define your gain below. >1 means amplifying it to be louder
            //let booster = AKBooster(player, gain: 1.3)
            let booster = AKBooster(currentPlayer, gain: Double(sliderGain.value))
            AudioKit.output = booster

            try AudioKit.start()

            currentPlayer?.play()
            print(currentPlayer?.isPlaying ?? false)
            
        } catch {
            // Log your error
        }
    }

    private func getPlayers() -> [AKAudioPlayer] {
        var players = [AKAudioPlayer]()
        
        wavList.forEach { wav in
            do {
                let file = try AKAudioFile(readFileName: wav)
                let player = try AKAudioPlayer(file: file, completionHandler: didFinishPlaying)
                players.append(player)
            } catch{
            }
        }
        
        return players
    }

    private func didFinishPlaying() {
        currentPlayer?.stop()
        print(currentPlayer?.isPlaying ?? false)
        
        do {
            try AudioKit.stop()
        } catch {
            // error
        }
        // 2セット目以降
        currentPlayerIndex += 1
        
        if currentPlayerIndex > players.count - 1 {
            print("done.")
            currentPlayerIndex = 0
            buttonAudio.isEnabled = true

            return
        }
        
        playAudio()
    }
}
