//
//  ContentView.swift
//  HEX2HSL
//
//  Created by Wayne Dahlberg on 7/15/24.
//

import SwiftUI

struct ContentView: View {
    @State private var hexColor: String = ""
    @State private var hslColor: String = ""
    @State private var selectedColor: Color = .black
    @State private var copyButtonText: String = "Copy HSL"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("HEX to HSL Converter")
                .font(.largeTitle)
            
            HStack {
                TextField("Enter HEX color", text: $hexColor)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150)
                
                ColorPicker("", selection: $selectedColor)
                    .onChange(of: selectedColor) { newValue in
                        hexColor = newValue.toHex() ?? ""
                        convertHexToHSL()
                    }
            }
            
            Button("Convert") {
                convertHexToHSL()
            }
            .keyboardShortcut(.return, modifiers: .command)
            
            Text(hslColor)
                .font(.title2)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: hexColor) ?? .clear))
                .foregroundColor(getContrastColor(for: Color(hex: hexColor) ?? .black))
            
            Button(copyButtonText) {
                copyHSLToClipboard()
            }
            .disabled(hslColor.isEmpty || hslColor == "Invalid HEX color")
        }
        .padding()
        .frame(width: 300, height: 300)
    }
    
    func convertHexToHSL() {
        guard let color = Color(hex: hexColor) else {
            hslColor = "Invalid HEX color"
            return
        }
        
        let (h, s, l) = color.toHSL()
      hslColor = String(format: "hsl(%.0f, %.0f%%, %.0f%%)", h.rounded(), (s * 100).rounded(), (l * 100).rounded())
    }
    
    func getContrastColor(for color: Color) -> Color {
        let (_, _, l) = color.toHSL()
        return l > 0.5 ? .black : .white
    }
    
    func copyHSLToClipboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(hslColor, forType: .string)
        
        copyButtonText = "Copied!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            copyButtonText = "Copy HSL"
        }
    }
}

#Preview {
  ContentView()
}
