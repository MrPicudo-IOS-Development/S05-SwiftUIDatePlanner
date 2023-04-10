/* DatePlannerApp.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import SwiftUI

@main // Con @main indicamos que la estructura "DatePlannerApp" es el punto de entrada de la aplicación.
/// Es la estructura inicial del programa, contiene un WindowGroup que a su vez contiene un NavigationView para mostrar todos los eventos en una lista.
struct DatePlannerApp: App {
    // Creamos un objeto de estado mutable que podremos compartir en varias vistas (sin necesidad de recrearse cada vez que cambiamos de vista).
    @StateObject private var eventData = EventData()

    var body: some Scene {
        // WindowGroup es un contenedor que administra automáticamente un conjunto de ventanas para sistemas operativos que permiten abrir múltiples ventanas al mismo tiempo.
        WindowGroup {
            // NavigationView es otro contenedor, que se encarga de la navegación entre distintas vistas de la aplicación.
            NavigationView {
                // Agregamos una vista personalizada al NavigationView
                EventList()
                Text("Select an Event")
                    .foregroundStyle(.secondary)
            }
            .environmentObject(eventData) // Pasamos el objeto de estado mutable "eventData" que creamos arriba, a todas las vistas hijas de la jerarquía de vistas. Así las vistas pueden acceder a los datos de eventos y compartir el mismo estado.

        }
    }
}

/* El objeto eventData sirve para almacenar la información de la aplicación, y se utiliza el @StateObject en su definición para que sea un "objeto observable". En cuando alguno de sus valores cambia, SwiftUI actualiza todas las vistas que están utilizando u observando el objeto. */
