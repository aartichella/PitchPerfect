//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Aarti Chella on 8/14/17.
//  Copyright © 2017 aarti. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        
        stopRecordingButton.imageView?.contentMode = .scaleAspectFit
        recordButton.imageView?.contentMode = .scaleAspectFit
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Function for changing state - edited after review

    func changeButtonState( state: Bool){
            recordButton.isEnabled = state ? false : true
            stopRecordingButton.isEnabled = state ? true : false
            recordLabel.text = state ? "Recording in progress" : "Recording in paused"
        
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
       
        changeButtonState(state: recordButton.isEnabled)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.delegate=self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordAudio(_ sender: AnyObject) {
       
        changeButtonState(state: recordButton.isEnabled)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        }
        else{
            print ("Recording was not successful")
        }
    }
    // MARK: - Segue to next Contoller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingSegue"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL=recordedAudioURL
    }

}

}
