//
//  MockData.swift
//  NotLang
//
//  Created by Amier Davis on 1/13/26.
//

import Foundation

// MARK: - French Translation Chunks
extension TranslationChunk {
    // Conversational Chunks
    static let bonjour = TranslationChunk(text: "Bonjour", translation: "Hello")
    static let commentCaVa = TranslationChunk(text: "comment ça va ?", translation: "how is it going?")
    static let caVaBien = TranslationChunk(text: "Ça va bien", translation: "It's going well")
    static let tellement = TranslationChunk(text: "tellement", translation: "so much")
    static let merci = TranslationChunk(text: "merci", translation: "thank you")
        
    // Dining & Requests
    static let jeVoudrais = TranslationChunk(text: "Je voudrais", translation: "I would like")
    static let unCroissant = TranslationChunk(text: "un croissant", translation: "a croissant")
    static let silVousPlait = TranslationChunk(text: "s'il vous plaît", translation: "please")
    
    // Description & Places
    static let laTourEiffel = TranslationChunk(text: "La tour Eiffel", translation: "The Eiffel Tower")
    static let estMagnifique = TranslationChunk(text: "est magnifique", translation: "is magnificent")
    static let jaime = TranslationChunk(text: "J'aime", translation: "I love")
    static let paris = TranslationChunk(text: "Paris", translation: "Paris")
    
    // Time & Weather
    static let ilFaitBeau = TranslationChunk(text: "Il fait beau", translation: "The weather is nice")
    static let aujourdhui = TranslationChunk(text: "aujourd'hui", translation: "today")
}

// MARK: - Multi-Language Translation Chunks
extension TranslationChunk {
    // Spanish Samples
    static let hola = TranslationChunk(text: "Hola", translation: "Hello")
    static let comoEstas = TranslationChunk(text: "¿cómo estás?", translation: "how are you?")
    static let meGusta = TranslationChunk(text: "Me gusta", translation: "I like")
    static let elCafe = TranslationChunk(text: "el café", translation: "the coffee")
    
    // Japanese Samples
    static let konnichiwa = TranslationChunk(text: "こんにちは", translation: "Hello")
    static let ogenki = TranslationChunk(text: "お元気ですか？", translation: "Are you well?")
    
    // Italian Samples
    static let grazie = TranslationChunk(text: "Grazie", translation: "Thank you")
    static let mille = TranslationChunk(text: "mille", translation: "a thousand")
    
    // French Samples (Additional)
    static let ouEst = TranslationChunk(text: "Où est", translation: "Where is")
    static let laBibliotheque = TranslationChunk(text: "la bibliothèque", translation: "the library")
    static let enchanté = TranslationChunk(text: "Enchanté", translation: "Nice to meet you")
    static let toutLeMonde = TranslationChunk(text: "tout le monde", translation: "everyone")
}

// MARK: - LangPost Samples
extension LangPost {
    // French Posts
    static let generalGreeting = LangPost(
        author: "Chloe",
        topic: "Greetings",
        content: [.bonjour, .commentCaVa]
    )
    
    static let bakeryOrder = LangPost(
        author: "Pierre",
        topic: "Dining",
        content: [.jeVoudrais, .unCroissant, .silVousPlait]
    )
    
    static let travelPost = LangPost(
        author: "Amier",
        topic: "Sightseeing",
        content: [.laTourEiffel, .estMagnifique]
    )
    
    static let cityLove = LangPost(
        author: "Lucie",
        topic: "Lifestyle",
        content: [.jaime, .paris, .tellement]
    )
    
    static let weatherUpdate = LangPost(
        author: "Jean",
        topic: "Weather",
        content: [.ilFaitBeau, .aujourdhui]
    )
    
    static let positiveResponse = LangPost(
        author: "Marie",
        topic: "Small Talk",
        content: [.caVaBien, .merci]
    )
    
    // International Posts
    static let spanishGreeting = LangPost(
        author: "Elena",
        topic: "Greetings",
        content: [.hola, .comoEstas]
    )
    
    static let coffeeLover = LangPost(
        author: "Marco",
        topic: "Food & Drink",
        content: [.meGusta, .elCafe]
    )
    
    static let japaneseIntro = LangPost(
        author: "Yuki",
        topic: "Greetings",
        content: [.konnichiwa, .ogenki]
    )
    
    static let italianGratitude = LangPost(
        author: "Luca",
        topic: "Etiquette",
        content: [.grazie, .mille]
    )
    
    static let frenchQuestion = LangPost(
        author: "Sophie",
        topic: "Directions",
        content: [.ouEst, .laBibliotheque]
    )
    
    static let socialMeeting = LangPost(
        author: "Amier",
        topic: "Social",
        content: [.enchanté, .toutLeMonde]
    )
}


extension LangPost {
    /// Source of truth for current JSON implementation of LangPost.
    static func mockJSONLangPost() -> LangPost {
        let jsonString = #"""
            {
            "author": "Zen_Vibes_Only (@Ines_Wellbeing)",
            "topic": "Morning routine"
            "content": [
            {
            "text": "Petit yoga",
            "translation": "Little yoga session"
            },
            {
            "text": "au calme",
            "translation": "in peace"
            },
            {
            "text": "avant de commencer",
            "translation": "before starting"
            },
            {
            "text": "la journée.",
            "translation": "the day."
            },
            {
            "text": "Il faut",
            "translation": "You have to"
            },
            {
            "text": "prendre soin de soi,",
            "translation": "take care of yourself,"
            },
            {
            "text": "c'est la base.",
            "translation": "it is the essential thing."
            }
            ]
            }
            """#
        
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(LangPost.self, from: jsonData)
        } catch {
            print("Decoding error: \(error)")
            return LangPost(author: "Error", topic: "N/A", content: [])
        }
    }
}
