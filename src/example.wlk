class Liga {
	var equipos //conjunto de equipos
	var representantes //conjunto de representantes
	
	method equipos() = equipos
	method representantes() = representantes
	
	method equipoConMasVision() {
		return equipos.max({equipo => equipo.vision()})
	}
	
	method destinosPosibles(jugadorX) {
		var destinosPosibles = #{}
		destinosPosibles.add(equipos.filter({equipo => equipo.leInteresa(jugadorX)}))
		destinosPosibles.add(representantes.filter({representante => representante.leInteresa(jugadorX)}))
		return destinosPosibles
	}
}


//------Equipos------

class Equipo {
	var jugadores //conjunto de jugadores
	var liga //instancia de clase Liga a la que pertenece
	
	method liga() = liga
	
	method potencia() {
		return jugadores.max({jugador => jugador.potencia()})
	}
	method precision() {
		return jugadores.sum({jugador => jugador.precision()})
	}
	method vision() {
		return jugadores.sum({jugador => jugador.visionGeneral()})
	}
	
	method leInteresa(jugadorX)
	method prefiereDescartar(jugadorX)
	
	method precisionPromedio() {
		return self.precision()/jugadores.size()
	}
	
	method puedeHacerTrato(representante) {
		var leInteresanAlRep = 0
		var interesanDelRep = 0
		jugadores.forEach({jugador => if(representante.leInteresa(jugador)) {leInteresanAlRep +=1}})
		representante.jugadores().forEach({jugador => if(self.leInteresa(jugador)) {interesanDelRep += 1}})
		return (leInteresanAlRep) >= 2 and (interesanDelRep >= 2)
 	}
}

class Lirico inherits Equipo {
	override method leInteresa(jugadorX) {
		return jugadorX.precision() > self.precisionPromedio()+2
	}
	
	override method prefiereDescartar(jugadorX) {
		return (jugadorX.precision() + jugadorX.visionGeneral()) <= 5
	}
}

class Rustico inherits Equipo {
	override method leInteresa(jugadorX) {
		return jugadores.count({jugador => jugador.potencia() > jugadorX.potencia()}) <= 3
	}
	
	override method prefiereDescartar(jugadorX) {
		return jugadorX.habilidadPases() > jugadorX.potencia()
	}
}

class Organizado inherits Equipo {
	override method leInteresa(jugadorX) {
		var atributosCumpliendo = 0
		
		if (jugadorX.valorIntrinseco() >= 8) {atributosCumpliendo +=1}
		if (jugadorX.habilidadPases() >= 8) {atributosCumpliendo += 1}
		if (jugadorX.visionGeneral() >= 8) {atributosCumpliendo += 1}
		
		return atributosCumpliendo >= 2
	}
	override method prefiereDescartar(jugadorX) {
		var atributosCumpliendo = 0
		
		if (jugadorX.valorIntrinseco() < 5) {atributosCumpliendo +=1}
		if (jugadorX.habilidadPases() < 5) {atributosCumpliendo += 1}
		if (jugadorX.visionGeneral() < 5) {atributosCumpliendo += 1}
		
		return atributosCumpliendo >= 2
	}
	
/*	method condicionesACumplir(jugador, valor) {
		return (jugador.valorIntrinseco() >= valor and jugador.habilidadPases() >= valor) or
			   (jugador.valorIntrinseco() >= valor and jugador.visionGeneral() >= valor) or
			   (jugador.habilidadPases() >= valor and jugador .visionGeneral() >= valor)
	} */
}


//------Jugadores------

class Jugador {
	const visionJuego //valor numerico
	const visionCompanieros //valor numerico
	const potencia //valor numerico
	const habilidadPases //valor numerico
	var duenio //instancia de clase equipo o representante
	
	method potencia() = potencia
	method habilidadPases() = habilidadPases
	
	method precision() {
		return 3*self.valorIntrinseco() + habilidadPases
	}
	method valorIntrinseco()
	
	method visionGeneral()
	
	method enRiesgo() {
		return duenio.prefiereDescartar(self)
	}
	
	method posiblesDestinos() {
		return duenio.liga().destinosPosibles()
	}
}

class Defensor inherits Jugador {
	const quite //valor numerico
	
	override method valorIntrinseco() = quite
	
	override method visionGeneral() {
		return visionJuego + visionCompanieros
	}
}

class Atacante inherits Jugador {
	const anotacion //valor numerico
	
	override method valorIntrinseco() = anotacion
	
	override method visionGeneral() {
		return visionJuego + habilidadPases
	}
}


//------Representantes------

class Representante {
	var pedidos //conjunto pedidos
	var jugadores //conjunto de jugadores
	var liga //instancia de clase Liga a la que pertenece
	
	method jugadores() = jugadores
	method liga() = liga
	
	method leInteresa(jugadorX) {
		return pedidos.any({pedido => pedido.satisface(jugadorX)})
	}
	
	method prefiereDescartar(jugadorX) {
		return not self.leInteresa(jugadorX)
	}
}


//------Pedidos------

class PedidoPotencia {
	var valorMin //numero
	
	method satisface(jugadorX) {
		return jugadorX.potencia() >= valorMin
	}
}

class PedidoVision {
	var valorMin //numero
	
	method satisface(jugadorX) {
		return jugadorX.visionGeneral() >= valorMin
	}
}

class PedidoCombinado {
	var valorMin //numero
	var valorMax //numero
	
	method satisface(jugadorX) {
		return valorMin < (jugadorX.visionGeneral() + jugadorX.precision() + jugadorX.habilidadPases()) < valorMax
	}
}