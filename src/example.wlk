class Liga {
	var equipos //conjunto de equipos
	
	method equipoConMasVision() {
		return equipos.max({equipo => equipo.vision()})
	}
}


//------Equipos------

class Equipo {
	var jugadores //conjunto de jugadores
	
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