//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by leanne on 1/28/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // MARK: - Properties
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:  AVAudioFile!
    
    // MARK: - UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up our audio player, engine, and recording, so ready to play user selection
        audioPlayer = try! AVAudioPlayer(contentsOf: receivedAudio.filePathURL as URL)
        audioPlayer.enableRate = true
        audioPlayer.rate = 1.0
        
        audioEngine = AVAudioEngine()
        
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL as URL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playAudioSlow(_ sender: UIButton) {
        let slowRate: Float = 0.5
        playAudioAtRate(slowRate)
    }

    // MARK: - InterfaceBuilder Actions
    @IBAction func playAudioFast(_ sender: UIButton) {
        let fastRate: Float = 1.5
        playAudioAtRate(fastRate)
    }
    
    @IBAction func playChipmunkAudio(_ sender: UIButton) {
        playAudioAtPitch(1000.0)
    }
    
    @IBAction func playDarthVaderAudio(_ sender: UIButton) {
        playAudioAtPitch(-1000.0)
    }

	@IBAction func playReverbAudio(_ sender: UIButton) {
		let echoWetDryMix: Float = 0.0
		let reverbMix: Float = 25.0
		playAudioWithEffect(echoWetDryMix, reverbWetDryMix: reverbMix)
	}

	@IBAction func playEchoAudio(_ sender: UIButton) {
		let echoWetDryMix: Float = 10.0
		let reverbMix: Float = 0.0
		playAudioWithEffect(echoWetDryMix, reverbWetDryMix: reverbMix)
	}

    @IBAction func stopSound(_ sender: UIButton) {
        resetAudio()
    }
    
    // MARK: - Utility Functions
    /**
    Stops and resets audio player and engine.
    */
    func resetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    /**
        Plays audio at specified rate.
        
        - Parameter rate: Speed at which to play audio.
     */
    func playAudioAtRate(_ rate: Float) {
        resetAudio()
        
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        
        audioPlayer.play()
    }
    
    /**
        Plays audio at specified pitch.
     
        - Parameter pitchVal: Pitch at which to play audio.
     */
    func playAudioAtPitch(_ pitchVal:Float) {
        resetAudio()
        
		// set up audio player node
		let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
		// set up pitch effect node
		let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = pitchVal
        audioEngine.attach(pitchEffect)
        
		// connect nodes to each other through audio engine
		audioEngine.connect(audioPlayerNode, to: pitchEffect, format: nil)
        audioEngine.connect(pitchEffect, to: audioEngine.outputNode, format: nil)
        
		// schedule the recording to play
		audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
		// start the engine and play the audio
		try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }

	/**
	Plays echo and reverb effects at specified wet/dry mix values.

	- Parameter echoWetDryMix: Wet/Dry mix for the echo portion of the effect.
	- Parameter reverbWetDryMix: Wet/Dry mix for the reverb portion of the effect.
	*/
	func playAudioWithEffect(_ echoWetDryMix: Float, reverbWetDryMix: Float) {
		resetAudio()

		// set up audio player node
		let audioPlayerNode = AVAudioPlayerNode()
		audioEngine.attach(audioPlayerNode)

		// set up delay node for echo
		let delayUnit = AVAudioUnitDelay()
		delayUnit.wetDryMix = echoWetDryMix
		audioEngine.attach(delayUnit)

		// set up reverb effect node
		let reverbEffect = AVAudioUnitReverb()
		reverbEffect.loadFactoryPreset(.cathedral)
		reverbEffect.wetDryMix = reverbWetDryMix
		audioEngine.attach(reverbEffect)

		// connect nodes to each other through audio engine
		audioEngine.connect(audioPlayerNode, to: delayUnit, format: nil)
		audioEngine.connect(delayUnit, to: reverbEffect, format: nil)
		audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)

		// schedule the recording to play
		audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)

		// start the engine and play the audio
		try! audioEngine.start()

		audioPlayerNode.play()

	}
    
}
