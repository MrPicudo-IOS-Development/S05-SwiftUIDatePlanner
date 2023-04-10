/* EventTask.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import Foundation

/// Con esta estructura creamos items que se agregan a una to-do list en cada evento. Se ajusta a los mismos protocolos de la estructura "Event", de manera que necesita un identificador único y puede manejar listas.
struct EventTask: Identifiable, Hashable {
    // Identificaro único
    var id = UUID()
    // Atributos de los items de las to-do list para cada evento.
    var text: String
    var isCompleted = false
    var isNew = false
}
