//
//  SpeechManager.swift
//  SwitchSpeak-iOS
//
//  Created by Robert Gerdisch on 3/19/18.
//  Copyright © 2018 SwitchSpeak. All rights reserved.
//

import Foundation
import AVKit

// A simplifying overlay of the speech synthesis API
class SpeechManager {
    private static var synthesizer:AVSpeechSynthesizer! = AVSpeechSynthesizer()
    
    // Start speaking a phrase or, if the synthesizer is already speaking,
    // enqueue the phrase to be spoken after the current phrase is uttered.
    static func say(phrase words:String, withVoice voiceName:String) {
        let utterance:AVSpeechUtterance = AVSpeechUtterance(string: words)
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if voice.name == voiceName {
                utterance.voice = voice
            }
        }
        synthesizer.speak(utterance)
    }
    
    // Pauses the synthesizer once it finishes the word it is currently
    // saying.
    static func pauseSpeech() {
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
    }
    
    // Immediately pauses the synthesizer.
    static func pauseSpeechNow() {
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    // Stops the synthesizer once it finishes the word it is currently
    // saying.
    static func stopSpeech() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.word)
    }
    
    // Immediately stops the synthesizer.
    static func stopSpeechNow() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    // Is the synthesizer paused?
    static func isPaused() -> Bool {
        return synthesizer.isPaused
    }
    
    // Is the synthesizer currently speaking?
    static func isSpeaking() -> Bool {
        return synthesizer.isSpeaking
    }
}
