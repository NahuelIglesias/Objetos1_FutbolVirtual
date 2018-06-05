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
}


//------Jugadores------

class Jugador {
	const visionJuego //valor numerico
	const visionCompanieros //valor numerico
	const potencia //valor numerico
	const habilidadPases //valor numerico
	
	method potencia() = potencia
	
	method precision() {
		return 3*self.valorIntrinseco() + habilidadPases
	}
	method valorIntrinseco()
	
	method visionGeneral()
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