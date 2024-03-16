//
//  indexPage.swift
//  EduQuest
//
//  Created by Alumno on 15/03/24.
//

import SwiftUI
import CoreData

struct IndexPage: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: RegistrationPage()) {
                    Text("Registrarse")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                NavigationLink(destination: LoginPage()) {
                    Text("Iniciar Sesión")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Menú")
        }
    }
}

struct RegistrationPage: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var exitoMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Nombre de usuario", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Contraseña", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Confirmar contraseña", text: $confirmPassword)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            if !exitoMessage.isEmpty {
                Text(exitoMessage)
                    .foregroundColor(.green)
            }

            Button("Registrarse") {
                registerUser()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Registrarse")
    }

    private func registerUser() {
        guard !username.isEmpty else {
            errorMessage = "El nombre de usuario no puede estar vacío"
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Las contraseñas no coinciden"
            return
        }

        // Guardar el usuario en CoreData
        let newUser = Person(context: PersistenceController.shared.container.viewContext)
        newUser.name = username
        newUser.password = password

        do {
            try PersistenceController.shared.container.viewContext.save()
            // Registro exitoso, limpiar campos y mostrar mensaje
            username = ""
            password = ""
            confirmPassword = ""
            exitoMessage = "Registro exitoso"
        } catch {
            errorMessage = "Error al guardar el usuario: \(error.localizedDescription)"
        }
    }
}

struct LoginPage: View {
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Nombre de usuario", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Contraseña", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Iniciar Sesión") {
                login()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("Iniciar Sesión")
    }

    private func login() {
        guard !username.isEmpty else {
            errorMessage = "El nombre de usuario no puede estar vacío"
            return
        }

        // Consultar usuario en CoreData
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", username)

        do {
            let users = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            if let user = users.first, user.password == password {
                // Inicio de sesión exitoso
                errorMessage = "Inicio de sesión exitoso"
            } else {
                // Nombre de usuario o contraseña incorrectos
                errorMessage = "Nombre de usuario o contraseña incorrectos"
            }
        } catch {
            errorMessage = "Error al buscar usuario: \(error.localizedDescription)"
        }
    }
}

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Users")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error al cargar el almacén persistente: \(error.localizedDescription)")
            }
        }
    }
}


#Preview {
    IndexPage()
}
