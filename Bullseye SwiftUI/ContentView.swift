//
//  ContentView.swift
//  Bullseye SwiftUI
//
//  Created by Eduardo Martin Lorenzo on 04/03/2021.
//

import SwiftUI

struct ContentView: View {
    
    // MARK:- Properties
    // ===========
    
    // MARK:- Colors
    let midnightBlue = Color(red: 0, green: 0.2, blue: 0.4)
    
    // MARK:- Game stats
    @State var score = 0
    @State var round = 1
    
    // MARK:- User Interface Views
    // Para saber si la pantalla debe estar en el ESTADO de mostrar la alerta o de no mostrarla. El @State permite que el struct "body" pueda modificar el valor de esta variable
    @State var alertIsVisible = false
    @State var sliderValue = Double.random(in: 1...100)
    @State var target = Int.random(in: 1...100)
    
    // No es necesario que sea una propiedad de estado ya que lo que cambia es sliderValue. Ademas las propiedades calculadas no pueden ser propiedades de estado
    var sliderValueRounded: Int {
        // El return es opcional al ser de una sola linea
        /*return */Int(sliderValue.rounded())
    }
    
    var sliderTargetDifference: Int {
        abs(sliderValueRounded - target)
    }
    // MARK:- UI
    var body: some View {
        // Se engloba todo en un NavigationView para que el boton "Info" pueda navegar a otra pantalla
        NavigationView {
            VStack {
                
                Spacer()
                
                // Target Row
                HStack {
                    Text("Put the bullseye as close as you can to:")
                        .modifier(LabelStyle())
                    Text("\(target)")
                        .modifier(ValueStyle())
                }
                
                Spacer()
                
                // Slider Row
                HStack {
                    Text("1")
                        .modifier(LabelStyle())
                    Slider(value: $sliderValue, in: 1...100)
                        .accentColor(.green)
                    Text("100")
                        .modifier(LabelStyle())
                }
                
                Spacer()
                
                // Button Row
                Button(action: {
                    print("Button pressed!")
                    self.alertIsVisible = true
                }, label: {
                    Text("Hit me!")
                        .modifier(ButtonLargeTextStyle())
                })
                .background(Image("Button")
                                .modifier(Shadow()))
                
                // $alertIsVisible permite hacer una conexion bidireccional entre alert y alertIsVisible, de tal forma que la alerta solo se mostrara si el bool es true y cuando la alerta lo cambia modificara el valor de alertIsVisible al valor contrario
                .alert(isPresented: $alertIsVisible) {
                    Alert(title: Text(alertTitle()), message: Text(scoringMessage()),    dismissButton: .default(Text("Awesome!")) {
                        self.startNewRound()
                    })
                }
                
                Spacer()
                
                // Score Row
                HStack {
                    Button(action: {startNewGame()}, label: {
                        HStack {
                            Image("StartOverIcon")
                            Text("Start over").modifier(ButtonSmallTextStyle())
                        }
                    }).background(Image("Button").modifier(Shadow()))
                    
                    Spacer()
                    
                    Text("Score")
                        .modifier(LabelStyle())
                    Text("\(score)")
                        .modifier(ValueStyle())
                    
                    Spacer()
                    
                    Text("Round:")
                        .modifier(LabelStyle())
                    Text("\(round)")
                        .modifier(ValueStyle())
                    
                    Spacer()
                    
                    // Para poder viajar a otra pantalla...
                    NavigationLink(
                        destination: AboutView()) {
                        HStack {
                            Image("InfoIcon")
                            Text("Info").modifier(ButtonSmallTextStyle())
                        }
                    }.background(Image("Button").modifier(Shadow()))
                }
                .padding(.bottom, 20)
                .padding(.leading, 20)
                .padding(.trailing, 40)
                .accentColor(midnightBlue)
            }
            // Permite cambiar el fondo cogiendo una imagen de Assets.xcassets
            .background(Image("Background"))
            // El .navigationBarTitle se puede colocar junto a cualquier de las vistas dentro del VStack o en el propio VStack ya que es el padre
            .navigationBarTitle("🎯 Bullseye 🎯")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK:- Methods
    func pointsForCurrentRound() -> Int {
        let points: Int
        if sliderTargetDifference == 0 {
            points = 200
        } else if sliderTargetDifference == 1 {
            points = 150
        } else {
            points = 100 - sliderTargetDifference
        }
        return points
    }
    
    func startNewRound() {
        score += pointsForCurrentRound()
        round += 1
        resetSliderAndTarget()
    }
    
    func startNewGame() {
        score = 0
        round = 1
        resetSliderAndTarget()
    }
    
    func resetSliderAndTarget() {
        sliderValue = Double.random(in: 1...100)
        target = Int.random(in: 1...100)
    }
    
    func alertTitle() -> String {
        let title: String
        if sliderTargetDifference == 0 {
            title = "Perfect!"
        } else if sliderTargetDifference < 5 {
            title = "You almost had id!"
        } else if sliderTargetDifference <= 10 {
            title = "Not bad."
        } else {
            title = "Are you even trying?"
        }
        return title
    }
    
    func scoringMessage() -> String {
        return "The slider's value is \(sliderValueRounded).\n" + "The target value is \(target).\n" + "You scored \(pointsForCurrentRound()) points this round."
    }
}

// MARK:- View Modifiers
struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(.white)
            .modifier(Shadow())
    }
}

struct ValueStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 24))
            .foregroundColor(.yellow)
            .modifier(Shadow())
    }
}

struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 5, x: 2, y: 2)
    }
}

struct ButtonLargeTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(.black)
    }
}

struct ButtonSmallTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 12))
            .foregroundColor(.black)
    }
}

// MARK:- Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
