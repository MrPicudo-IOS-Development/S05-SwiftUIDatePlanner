/* Event.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import SwiftUI

/// Contiene toda la información necesaria para ver y organizar eventos en nuestra lista. Se ajusta a los protocolos "Identifiable" y "Hashable" para que los eventos se puedan utilizar en listas y conjuntos, y además, que sean comparables por su identificador.
struct Event: Identifiable, Hashable {
    // Creamos el identificador necesario para el protocolo "Identifiable".
    var id = UUID()
    // Los siguientes atributos definen a todos los eventos que tendremos en nuestra app.
    var symbol: String = EventSymbols.randomName()
    var color: Color = ColorOptions.random()
    var title = ""
    var tasks = [EventTask(text: "")]
    var date = Date()

    // Creamos un atributo computable (que define su valor a partir de información obtenida al correr la app)
    var remainingTaskCount: Int {
        // Usamos un closure y el parámetro $0 para acceder al método .isCompleted, y contarlos (negados con !)
        tasks.filter { !$0.isCompleted }.count // Tareas que aún no están completadas en un evento.
    }
    
    // Con este atributo computable definimos si todas las tareas de un evento están completadas o no.
    var isComplete: Bool {
        tasks.allSatisfy { $0.isCompleted }
    }
    
    // Con este atributo computable verifica si la fecha del evento es anterior a la fecha actual del dispositivo, o no.
    var isPast: Bool {
        date < Date.now
    }
    
    // Verifica si el evento está dentro de los próximos 7 días (y no está en el pasado), o no.
    var isWithinSevenDays: Bool {
        !isPast && date < Date.now.sevenDaysOut
    }
    
    // Lo mismo, pero para el rango de 7 a 30 días.
    var isWithinSevenToThirtyDays: Bool {
        !isPast && !isWithinSevenDays && date < Date.now.thirtyDaysOut
    }
    
    // Verifica si un evento tiene más de 30 días de distancia.
    var isDistant: Bool {
        date >= Date().thirtyDaysOut
    }

    // Este es un evento de ejemplo que se puede usar en la aplicación para realizar pruebas.
    static var example = Event(
        symbol: "case.fill",
        title: "Sayulita Trip",
        tasks: [
            EventTask(text: "Buy plane tickets"),
            EventTask(text: "Get a new bathing suit"),
            EventTask(text: "Find an airbnb"),
        ],
        date: Date(timeIntervalSinceNow: 60 * 60 * 24 * 365 * 1.5))
}

// Convenience methods for dates.
// Swift ya tiene una estructura llamada "Date", y con esta extensión, le agregamos dos métodos que nos convienen para esta aplicación, llamados: sevenDaysOut y thirtyDaysOut, que devuelven una fecha que es 7 o 30 días en el futuro, a la fecha actual del dispositivo, respectivamente.
extension Date {
    var sevenDaysOut: Date {
        Calendar.autoupdatingCurrent.date(byAdding: .day, value: 7, to: self) ?? self
    }
    
    var thirtyDaysOut: Date {
        Calendar.autoupdatingCurrent.date(byAdding: .day, value: 30, to: self) ?? self
    }
}
