//
//  ContentView.swift
//  SwiftUILoginFireBase
//
//  Created by Diego Jurfest Ceccon on 18/08/20.
//  Copyright © 2020 ___DIEGOJURFESTCECCON___. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        NavigationView {
            VStack {
                if self.status {
                    
                    HomeScreen()
                    
                }
                else {
                    
                    ZStack {
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                            Text("")
                        }
                        .hidden()
                        
                        Login(show: self.$show)
                    }
                    
                    
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
    
}

struct HomeScreen: View {
    var body: some View {
        VStack {
            Text("Logged Successfully")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.7))
            
            Button(action: {
                
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }) {
                Text("Log out")
                    .foregroundColor(Color.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 25)
            
        }
    }
}

struct Login: View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var password = ""
    @State var visible = false
    @Binding var show: Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View {
        
        ZStack {
            ZStack(alignment: .topTrailing) {
                GeometryReader{_ in
                    
                    VStack {
                        Image("Swift_logo").resizable().frame(width: 50, height: 50)
                        Text("Log in to your account").font(.title).fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        
                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4)
                            .stroke(self.email != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                        
                        HStack(spacing: 15) {
                            VStack {
                                if self.visible {
                                    TextField("Password", text: self.$password)
                                        .autocapitalization(.none)
                                }
                                else {
                                    SecureField("Password", text: self.$password)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill").foregroundColor(self.color)
                            }
                        }.padding().background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("Color") : self.color, lineWidth: 2)).padding(.top, 25)
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                
                                self.reset()
                                
                            }) {
                                Text("Forget password")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Color"))
                            }
                        }.padding(.top, 20)
                        
                        Button(action: {
                            
                            self.verify()
                            
                        }) {
                            Text("Log in").foregroundColor(Color.white).padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }.background(Color("Color")).cornerRadius(10).padding(.top, 25)
                        
                    }.padding(.horizontal, 25)
                    
                    
                    
                    
                }
                
                Button(action: {
                    self.show.toggle()
                }) {
                    Text("Register").fontWeight(.bold).foregroundColor(Color("Color"))
                }.padding()
                
            }
            
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
            
        }
        
        
    }
    
    func verify() {
        if self.email != "" && self.password != "" {
            
            Auth.auth().signIn(withEmail: self.email, password: self.password) { (res, err) in
                
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }
            
            
        } else {
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
    
    func reset() {
        
        if self.email != "" {
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "RESET"
                self.alert.toggle()
                
                
            }
        } else {
            self.error = "Email Id is empty"
            self.alert.toggle()
        }
        
    }
    
}

struct SignUp: View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var visible = false
    @State var confirmVisible = false
    @Binding var show: Bool
    @State var alert = false
    @State var error = ""
    
    
    var body: some View {
        
        ZStack {
            ZStack(alignment: .topLeading) {
                GeometryReader{_ in
                    
                    VStack {
                        Image("Swift_logo").resizable().frame(width: 50, height: 50)
                        Text("Log in to your account").font(.title).fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        
                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4)
                            .stroke(self.email != "" ? Color("Color") : self.color, lineWidth: 2))
                            .padding(.top, 25)
                        
                        HStack(spacing: 15) {
                            VStack {
                                if self.visible {
                                    TextField("Password", text: self.$password)
                                        .autocapitalization(.none)
                                }
                                else {
                                    SecureField("Password", text: self.$password)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill").foregroundColor(self.color)
                            }
                        }.padding().background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("Color") : self.color, lineWidth: 2)).padding(.top, 25)
                        
                        // begin confirm password
                        HStack(spacing: 15) {
                            VStack {
                                if self.confirmVisible {
                                    TextField("Re-enter password", text: self.$confirmPassword)
                                    .autocapitalization(.none)
                                }
                                else {
                                    SecureField("Re-enter password", text: self.$confirmPassword)
                                    .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.confirmVisible.toggle()
                                
                            }) {
                                Image(systemName: self.confirmVisible ? "eye.slash.fill" : "eye.fill").foregroundColor(self.color)
                            }
                        }.padding().background(RoundedRectangle(cornerRadius: 4).stroke(self.confirmPassword != "" ? Color("Color") : self.color, lineWidth: 2)).padding(.top, 25)
                        
                        // end confirm password
                        
                        
                        Button(action: {
                            
                            self.register()
                            
                        }) {
                            Text("Register").foregroundColor(Color.white).padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }.background(Color("Color")).cornerRadius(10).padding(.top, 25)
                        
                    }.padding(.horizontal, 25)
                    
                    
                    
                    
                }
                
                Button(action: {
                    self.show.toggle()
                }) {
                    Image(systemName: "chevron.left").font(.title).foregroundColor(Color("Color"))
                }.padding()
                
            }
            
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        .navigationBarBackButtonHidden(true)
        
        
    }
    
    func register() {
        
        
        
        if self.email != "" {
            
            if self.password == self.confirmPassword {
                print("guimaroes")
                Auth.auth().createUser(withEmail: self.email, password: self.password) { (res, err) in
                    
                    if err != nil {
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    print("User successfully register")
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                }
                
            }
            else {
                self.error = "Password mismatch"
                self.alert.toggle()
            }
        }
        else {
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
    
    
    
}

struct ErrorView: View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert: Bool
    @Binding var error: String
    
    var body: some View {
        
        GeometryReader {_ in
            
            VStack{
                HStack{
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    self.alert.toggle()
                }) {
                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
            
            
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
    
}
