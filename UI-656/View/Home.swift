//
//  Home.swift
//  UI-656
//
//  Created by nyannyan0328 on 2022/08/29.
//

import SwiftUI

struct Home: View {
    @State var activeGlassMorphism : Bool = false
    @State var defaultBlurRadius : CGFloat = 0
    @State var defaultSatulationAmount : CGFloat = 0
    @State var blurView : UIVisualEffectView = .init()
    var body: some View {
        ZStack{
            
            Image("TopCircle")
                .offset(x:260,y:-50)
            
            Image("CenterCircle")
                .offset(x:0,y:100)
            
            
            
            Image("BottomCircle")
                .offset(x:-220,y:150)
            
            Toggle("Acitive Glass Morphism", isOn: $activeGlassMorphism)
                .font(.headline)
                .foregroundColor(.cyan)
                .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .bottom)
                .padding(.vertical,10)
                .padding(.horizontal)
                .onChange(of: activeGlassMorphism) { newValue in
                    
                    
                    blurView.gaussinaBlurRadius = (activeGlassMorphism ? 10 : defaultBlurRadius)
                    
                    blurView.staturationAmount =  (activeGlassMorphism ? 1.8 : defaultSatulationAmount)
                }
            
            
            
            
            
                 GlassMorphics()
            
            
        }
    }
    @ViewBuilder
    func GlassMorphics()->some View{
        
        
        ZStack{
            
            CustomBlurView(effect: .systemThickMaterialDark) { view in
                
                 blurView = view
                if defaultBlurRadius == 0{defaultBlurRadius = view.gaussinaBlurRadius}
                
                if defaultSatulationAmount == 0{
                    
                    defaultSatulationAmount = view.staturationAmount
                    
                }
                
                
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
            
            RoundedRectangle(cornerRadius: 10,style: .continuous)
                .fill(
                    
                    LinearGradient(colors: [
                        
                        .white.opacity(0.3),
                        .white.opacity(0.3)
                        
                        
                        
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    
                )
                .blur(radius: 5)
            
            RoundedRectangle(cornerRadius: 10,style: .continuous)
                .stroke(
                    
                    LinearGradient(colors: [
                        
                        .white.opacity(0.6),
                        .clear,
                        .purple.opacity(0.2),
                        .purple.opacity(0.5)
                        
                        
                        
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    
                )
            
        }
        .shadow(color :.black.opacity(0.15), radius: 5,x: -10,y:-10)
        .shadow(color :.black.opacity(0.15), radius: 5,x: 10,y:-10)
        .overlay(content: {
            
            CardContent()
                .opacity(activeGlassMorphism ? 1 : 0)
                .animation(.easeOut(duration: 0.5), value: activeGlassMorphism)
        })
        .padding(.horizontal)
        .frame(height:220)
        
    }
    @ViewBuilder
    func CardContent()->some View{
        
        VStack(alignment:.leading,spacing: 10){
            
            
            HStack{
                
                Text("Menmber Ship".uppercased())
                    .modifier(CustomModifier(font: .body, weight: .black))
                
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50,height: 50)
                    .clipShape(Circle())
                
                
            }
            
            Spacer()
            
            Text("King of Animal")
                .modifier(CustomModifier(font: .footnote, weight: .black))
            
            Text("Lion")
                .modifier(CustomModifier(font: .footnote, weight: .black))
            
        }
        .padding(20)
        .padding(.vertical)
        .blendMode(.overlay)
        .frame(maxWidth: .infinity,maxHeight : .infinity,alignment: .topLeading)
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIView{
    
    func subView(forClass : AnyClass?)->UIView?{
        
        return subviews.first { view in
            
            type(of: view) == forClass
        }
    }
    
}

extension UIVisualEffectView{
    
    var backDrop : UIView?{
        return subView(forClass: NSClassFromString("_UIVisualEffectBackdropView"))
        
    }
    var gaussinaBlur : NSObject?{
     
        return backDrop?.value(key: "filters", filter: "gaussianBlur")
        
    }
    var staturation : NSObject?{
        
        
        return backDrop?.value(key: "filters", filter: "colorSaturate")
    }
    
    var gaussinaBlurRadius : CGFloat{
        
        get{
            return gaussinaBlur?.values?["inputRadius"] as? CGFloat ?? 0
            
        }
        
        set{
            
            gaussinaBlur?.values?["inputRadius"] = newValue
            
            applyNewEffects()
        }
    }
    
    func applyNewEffects(){
        UIVisualEffectView.animate(withDuration: 0.5) {
            
            self.backDrop?.perform(Selector(("applyRequestedFilterEffects")))
        }
        
    }
    
    var staturationAmount : CGFloat{
        
        get{
            
            return staturation?.values?["inputAmount"] as? CGFloat ?? 0
        }
        set{
            
            staturation?.values?["inputAmount"] = newValue
            applyNewEffects()
            
        }
    }
    
    
}
extension NSObject{
    
    var values : [String : Any]?{
        
        get{
            
            return value(forKeyPath: "requestedValues") as? [String : Any]
            
        }
        set{
             value(forKeyPath: "requestedValues")
            
            
        }
        
    }
    func value(key : String,filter : String) -> NSObject?{
        
        
        (value(forKey: key) as? [NSObject])?.first(where: { obj in
            
            return obj.value(forKey: "filterType") as? String == filter
        })
    }
}

struct CustomModifier : ViewModifier{
    
    var font : Font
    var weight : Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .fontWeight(weight)
            .foregroundColor(.white)
            .kerning(1.2)
            .shadow(radius:5)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
}

struct CustomBlurView : UIViewRepresentable{
    
    var effect : UIBlurEffect.Style
    var onChange : (UIVisualEffectView) -> ()
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
        
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
        DispatchQueue.main.async {
            
            onChange(uiView)
        }
    }
}
