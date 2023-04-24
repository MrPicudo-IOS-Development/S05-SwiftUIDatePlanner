/* *** *** *** REFERENCE *** *** *** */
/*

/* ColorOption.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import SwiftUI

struct ColorOptions {
    static var all: [Color] = [
        .primary,
        .gray,
        .red,
        .orange,
        .yellow,
        .green,
        .mint,
        .cyan,
        .indigo,
        .purple,
    ]
    
    static var `default` : Color = Color.primary
    
    static func random() -> Color {
        if let element = ColorOptions.all.randomElement() {
            return element
        } else {
            return .primary
        }
        
    }
}



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



/* EventData.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import SwiftUI

/// Esta estructura contiene toda la información de los eventos agregados a la aplicación. Se ajusta al protocolo ObservableObject de manera que si alguno de los valores de esta estructura cambia, SwiftUI actualiza todas las vistas que utilizan sus valores.
class EventData: ObservableObject {
    // La propiedad o atributo "events" es un arreglo observable de objetos de tipo "Event", que notifica a todos los observadores del arreglo (otras vistas), cada vez que se realiza algún cambio.
    @Published var events: [Event] = [
        Event(symbol: "gift.fill",
              color: .red,
              title: "Maya's Birthday",
              tasks: [EventTask(text: "Guava kombucha"),
                      EventTask(text: "Paper cups and plates"),
                      EventTask(text: "Cheese plate"),
                      EventTask(text: "Party poppers"),
                     ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 30)),
        Event(symbol: "theatermasks.fill",
              color: .yellow,
              title: "Pagliacci",
              tasks: [EventTask(text: "Buy new tux"),
                      EventTask(text: "Get tickets"),
                      EventTask(text: "Pick up Carmen at the airport and bring her to the show"),
                     ],
              date: Date.roundedHoursFromNow(60 * 60 * 22)),
        Event(symbol: "facemask.fill",
              color: .indigo,
              title: "Doctor's Appointment",
              tasks: [EventTask(text: "Bring medical ID"),
                      EventTask(text: "Record heart rate data"),
                     ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 4)),
        Event(symbol: "leaf.fill",
              color: .green,
              title: "Camping Trip",
              tasks: [EventTask(text: "Find a sleeping bag"),
                      EventTask(text: "Bug spray"),
                      EventTask(text: "Paper towels"),
                      EventTask(text: "Food for 4 meals"),
                      EventTask(text: "Straw hat"),
                     ],
              date: Date.roundedHoursFromNow(60 * 60 * 36)),
        Event(symbol: "gamecontroller.fill",
              color: .cyan,
              title: "Game Night",
              tasks: [EventTask(text: "Find a board game to bring"),
                      EventTask(text: "Bring a desert to share"),
                     ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 2)),
        Event(symbol: "graduationcap.fill",
              color: .primary,
              title: "First Day of School",
              tasks: [
                  EventTask(text: "Notebooks"),
                  EventTask(text: "Pencils"),
                  EventTask(text: "Binder"),
                  EventTask(text: "First day of school outfit"),
              ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 365)),
        Event(symbol: "book.fill",
              color: .purple,
              title: "Book Launch",
              tasks: [
                  EventTask(text: "Finish first draft"),
                  EventTask(text: "Send draft to editor"),
                  EventTask(text: "Final read-through"),
              ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 365 * 2)),
        Event(symbol: "globe.americas.fill",
              color: .gray,
              title: "WWDC",
              tasks: [
                  EventTask(text: "Watch Keynote"),
                  EventTask(text: "Watch What's new in SwiftUI"),
                  EventTask(text: "Go to DT developer labs"),
                  EventTask(text: "Learn about Create ML"),
              ],
              date: Date.from(month: 6, day: 7, year: 2021)),
        Event(symbol: "case.fill",
              color: .orange,
              title: "Sayulita Trip",
              tasks: [
                  EventTask(text: "Buy plane tickets"),
                  EventTask(text: "Get a new bathing suit"),
                  EventTask(text: "Find a hotel room"),
              ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 19)),
    ]

    // Método para borrar eventos
    func delete(_ event: Event) {
        events.removeAll { $0.id == event.id }
    }
    
    // Método para agregar un evento nuevo
    func add(_ event: Event) {
        events.append(event)
    }
    
    // Método que verifica si un evento ya existe en la lista
    func exists(_ event: Event) -> Bool {
        events.contains(event)
    }
    
    // Devuelve todos los eventos que se encuentran en un determinado periodo de tiempo
    func sortedEvents(period: Period) -> Binding<[Event]> {
        Binding<[Event]>(
            get: {
                self.events
                    .filter {
                        switch period {
                        case .nextSevenDays:
                            return $0.isWithinSevenDays
                        case .nextThirtyDays:
                            return $0.isWithinSevenToThirtyDays
                        case .future:
                            return $0.isDistant
                        case .past:
                            return $0.isPast
                        }
                    }
                    .sorted { $0.date < $1.date }
            },
            set: { events in
                for event in events {
                    if let index = self.events.firstIndex(where: { $0.id == event.id }) {
                        self.events[index] = event
                    }
                }
            }
        )
    }
}

// Define las categorías de tiempo que vamos a usar para ordenar la lista de eventos.
enum Period: String, CaseIterable, Identifiable {
    case nextSevenDays = "Next 7 Days"
    case nextThirtyDays = "Next 30 Days"
    case future = "Future"
    case past = "Past"
    
    var id: String { self.rawValue }
    var name: String { self.rawValue }
}

// Extensiones a la estructura Date
extension Date {
    static func from(month: Int, day: Int, year: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let calendar = Calendar(identifier: .gregorian)
        if let date = calendar.date(from: dateComponents) {
            return date
        } else {
            return Date()
        }
    }

    static func roundedHoursFromNow(_ hours: Double) -> Date {
        let exactDate = Date(timeIntervalSinceNow: hours)
        guard let hourRange = Calendar.current.dateInterval(of: .hour, for: exactDate) else {
            return exactDate
        }
        return hourRange.end
    }
}



/* EventDetail.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import SwiftUI

struct EventDetail: View {
    @Binding var event: Event
    let isEditing: Bool
    
    @State private var isPickingSymbol = false
    
    var body: some View {
        List {

            HStack {
                Button {
                    isPickingSymbol.toggle()
                } label: {
                    Image(systemName: event.symbol)
                        .sfSymbolStyling()
                        .foregroundColor(event.color)
                        .opacity(isEditing ? 0.3 : 1)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 5)

                if isEditing {
                    TextField("New Event", text: $event.title)
                        .font(.title2)
                } else {
                    Text(event.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            
            if isEditing {
                DatePicker("Date", selection: $event.date)
                    .labelsHidden()
                    .listRowSeparator(.hidden)

            } else {
                HStack {
                    Text(event.date, style: .date)
                    Text(event.date, style: .time)
                }
                .listRowSeparator(.hidden)
            }
            
            Text("Tasks")
                .fontWeight(.bold)
            
            ForEach($event.tasks) { $item in
                TaskRow(task: $item, isEditing: isEditing)
            }
            .onDelete(perform: { indexSet in
                event.tasks.remove(atOffsets: indexSet)
            })
            
            Button {
                event.tasks.append(EventTask(text: "", isNew: true))
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Task")
                }
            }
            .buttonStyle(.borderless)
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(isPresented: $isPickingSymbol) {
            SymbolPicker(event: $event)
        }
    }
}

struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail(event: .constant(Event.example), isEditing: true)
    }
}



/* EventEditor.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import SwiftUI

struct EventEditor: View {
    @Binding var event: Event
    var isNew = false
    
    @State private var isDeleted = false
    @EnvironmentObject var eventData: EventData
    @Environment(\.dismiss) private var dismiss
    
    // Keep a local copy in case we make edits, so we don't disrupt the list of events.
    // This is important for when the date changes and puts the event in a different section.
    @State private var eventCopy = Event()
    @State private var isEditing = false
    
    private var isEventDeleted: Bool {
        !eventData.exists(event) && !isNew
    }
    
    var body: some View {
        VStack {
            EventDetail(event: $eventCopy, isEditing: isNew ? true : isEditing)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        if isNew {
                            Button("Cancel") {
                                dismiss()
                            }
                        }
                    }
                    ToolbarItem {
                        Button {
                            if isNew {
                                eventData.events.append(eventCopy)
                                dismiss()
                            } else {
                                if isEditing && !isDeleted {
                                    print("Done, saving any changes to \(event.title).")
                                    withAnimation {
                                        event = eventCopy // Put edits (if any) back in the store.
                                    }
                                }
                                isEditing.toggle()
                            }
                        } label: {
                            Text(isNew ? "Add" : (isEditing ? "Done" : "Edit"))
                        }
                    }
                }
                .onAppear {
                    eventCopy = event // Grab a copy in case we decide to make edits.
                }
                .disabled(isEventDeleted)

            if isEditing && !isNew {

                Button(role: .destructive, action: {
                    isDeleted = true
                    dismiss()
                    eventData.delete(event)
                }, label: {
                    Label("Delete Event", systemImage: "trash.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                })
                    .padding()
            }
        }
        .overlay(alignment: .center) {
            if isEventDeleted {
                Color(UIColor.systemBackground)
                Text("Event Deleted. Select an Event.")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct EventEditor_Previews: PreviewProvider {
    static var previews: some View {
        EventEditor(event: .constant(Event()))
    }
}



/* EventList.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import SwiftUI

struct EventList: View {
    @EnvironmentObject var eventData: EventData
    @State private var isAddingNewEvent = false
    @State private var newEvent = Event()
    
    var body: some View {
        
        List {
            ForEach(Period.allCases) { period in
                if !eventData.sortedEvents(period: period).isEmpty {
                    Section(content: {
                        ForEach(eventData.sortedEvents(period: period)) { $event in
                            NavigationLink {
                                EventEditor(event: $event)
                            } label: {
                                EventRow(event: event)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    eventData.delete(event)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }, header: {
                        Text(period.name)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                    })
                }
            }
        }
        .navigationTitle("Date Planner")
        .toolbar {
            ToolbarItem {
                Button {
                    newEvent = Event()
                    isAddingNewEvent = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddingNewEvent) {
            NavigationView {
                EventEditor(event: $newEvent, isNew: true)
            }
        }
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventList().environmentObject(EventData())

        }
    }
}



/* EventRow.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import SwiftUI

struct EventRow: View {
    let event: Event
    
    var body: some View {
        HStack {
            Image(systemName: event.symbol)
                .sfSymbolStyling()
                .foregroundStyle(event.color)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(event.title)
                    .fontWeight(.bold)

                Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            if event.isComplete {
                Spacer()
                Image(systemName: "checkmark")
                    .foregroundStyle(.secondary)
            }
            
        }
        .badge(event.remainingTaskCount)
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow(event: Event.example)
    }
}



/* EventSymbols.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import Foundation

struct EventSymbols {
    static func randomName() -> String {
        if let random = symbolNames.randomElement() {
            return random
        } else {
            return ""
        }
    }
    
    static func randomNames(_ number: Int) -> [String] {
        var names: [String] = []
        for _ in 0..<number {
            names.append(randomName())
        }
        return names
    }
        
    static var symbolNames: [String] = [
        "house.fill",
        "ticket.fill",
        "gamecontroller.fill",
        "theatermasks.fill",
        "ladybug.fill",
        "books.vertical.fill",
        "moon.zzz.fill",
        "umbrella.fill",
        "paintbrush.pointed.fill",
        "leaf.fill",
        "globe.americas.fill",
        "clock.fill",
        "building.2.fill",
        "gift.fill",
        "graduationcap.fill",
        "heart.rectangle.fill",
        "phone.bubble.left.fill",
        "cloud.rain.fill",
        "building.columns.fill",
        "mic.circle.fill",
        "comb.fill",
        "person.3.fill",
        "bell.fill",
        "hammer.fill",
        "star.fill",
        "crown.fill",
        "briefcase.fill",
        "speaker.wave.3.fill",
        "tshirt.fill",
        "tag.fill",
        "airplane",
        "pawprint.fill",
        "case.fill",
        "creditcard.fill",
        "infinity.circle.fill",
        "dice.fill",
        "heart.fill",
        "camera.fill",
        "bicycle",
        "radio.fill",
        "car.fill",
        "flag.fill",
        "map.fill",
        "figure.wave",
        "mappin.and.ellipse",
        "facemask.fill",
        "eyeglasses",
        "tram.fill",
    ]
}



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



/* SFSymbolStyling.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import SwiftUI

struct SFSymbolStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .imageScale(.large)
            .symbolRenderingMode(.monochrome)
    }
}

extension View {
    func sfSymbolStyling() -> some View {
        modifier(SFSymbolStyling())
    }
}



/* SymbolPicker.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import SwiftUI

struct SymbolPicker: View {
    @Binding var event: Event
    @State private var selectedColor: Color = ColorOptions.default
    @Environment(\.dismiss) private var dismiss
    @State private var symbolNames = EventSymbols.symbolNames
    @State private var searchInput = ""
    
    var columns = Array(repeating: GridItem(.flexible()), count: 6)

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
                .padding()
            }
            HStack {
                Image(systemName: event.symbol)
                    .font(.title)
                    .imageScale(.large)
                    .foregroundColor(selectedColor)

            }
            .padding()

            HStack {
                ForEach(ColorOptions.all, id: \.self) { color in
                    Button {
                        selectedColor = color
                        event.color = color
                    } label: {
                        Circle()
                            .foregroundColor(color)
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: 40)

            Divider()

            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(symbolNames, id: \.self) { symbolItem in
                        Button {
                            event.symbol = symbolItem
                        } label: {
                            Image(systemName: symbolItem)
                                .sfSymbolStyling()
                                .foregroundColor(selectedColor)
                                .padding(5)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .drawingGroup()
            }
        }
        .onAppear {
            selectedColor = event.color
        }
    }
}

struct SFSymbolBrowser_Previews: PreviewProvider {
    static var previews: some View {
        SymbolPicker(event: .constant(Event.example))
    }
}



/* TaskRow.swift --> DatePlanner. Created by Miguel Torres on 09/04/2023. */

import SwiftUI

struct TaskRow: View {
    @Binding var task: EventTask
    var isEditing: Bool
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
            }
            .buttonStyle(.plain)

            if isEditing || task.isNew {
                TextField("Task description", text: $task.text)
                    .focused($isFocused)
                    .onChange(of: isFocused) { newValue in
                        if newValue == false {
                            task.isNew = false
                        }
                    }

            } else {
                Text(task.text)
            }

            Spacer()
        }
        .padding(.vertical, 10)
        .task {
            if task.isNew {
                isFocused = true
            }
        }
    }
        
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(task: .constant(EventTask(text: "Do something!")), isEditing: false)
    }
}

*/
