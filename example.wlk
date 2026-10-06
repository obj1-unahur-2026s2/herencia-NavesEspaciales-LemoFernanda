// Naves especiales 
class Nave {
var velocidad = 0
var direccion = 0 // numero entre -10 y 10
var combustible = 0

method velocidad() = velocidad
method direccion() = direccion
method  combustible() = combustible



method cargarCombustible(cuanto){
combustible += cuanto
}

method acelerar(cuanto) {
velocidad = (velocidad + cuanto).min(100000)
}

method descargarCombustible(cuanto){
combustible = (combustible - cuanto).max(0)
}



method desacelerar(cuanto){
velocidad = (velocidad - cuanto).max(0)
}

method irHaciaElSol() {
direccion = 10
}

method escaparDelSol() {
direccion= -10
}

method ponerseParaleloAlSol() {
direccion = 0
}

// -10 si el sol se aleja y 10 si el sol se acerca
method acercarseUnPocoAlSol(){
direccion = (direccion + 1).min(10)
}

method alejarseUnPocoDelSol() {
direccion = (direccion - 1).max(-10)

}
method prepararViaje() {
self.cargarCombustible(30000)
self.acelerar(5000)
}

method estaTranquila(){
return combustible >= 4000 and velocidad <= 12000
}

method recibirAmenaza() {
self.escapar()
self.avisar()
}

method escapar()
method avisar()

method estaDeRelajo(){
return self.estaTranquila() and self.tienePocaActividad()
}
method tienePocaActividad()
}


//Distintos tipos de nave

// Naves-baliza
class NaveBaliza inherits Nave {
var baliza = "rojo"
var cambioDeColor = false 

method cambioDeColor() = cambioDeColor
method baliza() = baliza

method cambiarColorDeBaliza(colorNuevo) {
  baliza = colorNuevo
  cambioDeColor = true
}
override method tienePocaActividad(){
return not cambioDeColor
}

override method estaTranquila() {
return super() and baliza != "rojo"
}

override method prepararViaje() {
super()
self.cambiarColorDeBaliza("verde")
self.ponerseParaleloAlSol()
}
override method escapar() {
self.irHaciaElSol()
}
override method avisar() {
self.cambiarColorDeBaliza("rojo")
}


}
// Nave de pasajeros
class NaveDePasajeros inherits Nave {
var cantidadDePasajeros = 0
var racionesDeComida = 0
var racionesDeBebida = 0
var racionesServidas = 0

method cantidadDePasajeros() = cantidadDePasajeros
method racionesDeComida() = racionesDeComida
method racionesDeBebida() = racionesDeBebida

method cargarComida(cuanto) {
racionesDeComida += cuanto
}

method descargarComida(cuanto){
  const aDescargar = cuanto.min(racionesDeComida)
  racionesDeComida -= aDescargar
  racionesServidas += aDescargar
}

override method tienePocaActividad(){
return racionesServidas < 50
}

method cargarBebida(cuanto){
racionesDeBebida += cuanto
}
method descargarBebida(cuanto) {
racionesDeBebida = (racionesDeBebida - cuanto).max(0)
}
override method prepararViaje() {
super()
self.cargarComida(cantidadDePasajeros * 4)
self.cargarBebida(cantidadDePasajeros * 6)
self.acercarseUnPocoAlSol()
}

override method escapar(){
self.acelerar(velocidad)
}
override method avisar() {
self.descargarComida(cantidadDePasajeros * 1)
self.descargarBebida(cantidadDePasajeros * 2)
}

}

// Naves de combate 
class NaveDeCombate inherits Nave {
var  estaInvisible = false
var misilesDesplegados = false
const mensajesEmitidos = []

method estaInvisible() = estaInvisible
method ponerseVisible() { 
estaInvisible = false 
}
method ponerseInvisible() {
estaInvisible = true
}


method misilesDesplegados() = misilesDesplegados
method desplegarMisiles() {
misilesDesplegados = true
}
method replegarMisiles() {
misilesDesplegados = false
}
method mensajesEmitidos() = mensajesEmitidos

method emitirMensaje(mensaje) {
mensajesEmitidos.add(mensaje)
}

method primerMensajeEmitido() = mensajesEmitidos.first()
method ultimoMensajeEmitido() = mensajesEmitidos.last()

method esEscueta() = mensajesEmitidos.all({ m => m.size() <= 30 })

override method estaTranquila() {
return super() and not misilesDesplegados 
}

override method prepararViaje() {
super()
self.ponerseVisible()
self.replegarMisiles()
self.acelerar(15000)
self.emitirMensaje("Saliendo en mision")
}

override method escapar() {
self.acercarseUnPocoAlSol()
self.acercarseUnPocoAlSol()
}

override method avisar() {
self.emitirMensaje("Amenaza recibida")
}

override method tienePocaActividad() {
    return self.esEscueta()
  }
}


class NaveDeCombateSigilosa inherits NaveDeCombate {
override method estaTranquila() {
return super() and not estaInvisible
}
override method escapar() {
super()
self.desplegarMisiles()
self.ponerseInvisible()
}
}



class NaveHospital inherits NaveDePasajeros {
var quirofanosPreparados = false

method quirofanosPreparados() = quirofanosPreparados
method prepararQuirofanos () {
quirofanosPreparados = true
}
method noPrepararQuirofanos() {
quirofanosPreparados  = false
}
override method estaTranquila() {
return super() and not quirofanosPreparados
}
override method recibirAmenaza() {
super()
self.prepararQuirofanos()
}
}