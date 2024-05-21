/*
Tipos de poderes:

* VELOCIDAD: se define con una rapidez (num)
 
		|-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-|
		| 	agilidad: estrategia * rapidez			|
		|											|
		|	fuerza: espiritualidad * rapidez		|
		|											|
		|	habilidad: espiritualidad + estrategia 	|
		|-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-| 
		 
* VUELO: se define con una altura maxima (num) y una energia para
		 despegue (num)
		 
		|-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-|
		| 	agilidad: ( (estrategia * alturaMax) / energiaDespegue )    |
		|																|
		|	fuerza: ( (espiritualidad + alturaMax) - energiaDespegue )	|
		|																|
		|	habilidad: espiritualidad + estrategia 						|
		|-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-|
  
* PODER AMPLIFICADOR: tiene un poderBase y un nro amplificador A 
 
		|-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-|
		| 	agilidad: agilidad que aporta el poderBase al personaje	|
		|															|
		|	fuerza: fuerza que aporta el poderBase al personaje		|
		|															|
		|	habilidad: habilidad x poderBase * amplificador A 		|
		|-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.- 
 
***********REQUERIMIENTOS PARTE 1***********
1) Saber la capacidad de batalla que un poder otorga al heroe
2) Saber la capacidad de batalla de un personaje

Resumen: personaje es una clase con estrategia e espiritualidad. cada personaje
tiene poderes y una capacidad de batalla especifica.

Poderes es una clase que tiene una capacidad de batalla fija en su calculo y con una agilidad,
fuerza y habilidad especial variables segun el personaje y el tipo de poder.
*/

//Parte 1: poderes y personajes
class Personaje{
	var property espiritualidad
	var property estrategia
	const poderes = []
	
	//E capacidades de batalla de sus poderes adecuado a c/personaje
	method capacidadBatalla(){
		return poderes.sum( {poder => poder.capacidadBatalla(self)} )
	}
	
	//Para determinar el mejor poder:
	method mejorPoder()= poderes.max( {poder=> poder.capacidadBatalla(self)} )
	
	method inmuneRadiacion()= poderes.any({poder => poder.inmuneRadiacion()})
	
	method comparaCapacidad(peligro)= self.capacidadBatalla() > peligro.capacidadBatalla() //Devuelve true or false
	
	//Puede enfrentar un peligro si su cap.Batalla es MAYOR que la del peligro
	//y si es inmune. No importa si es inmune si el peligro NO es radioactivo por 
	//lo que deberia haber una validacion extra para no sumar una condicion que en
	//algunos casos no es importante. Entonces...
	method manejarRadiactividad(peligro){
		if(peligro.desechosRadiactivos()){
			return self.inmuneRadiacion()
		}else{
			return true
		}
	}
	
	method enfrentaPeligro(peligro)= self.comparaCapacidad(peligro) && self.manejarRadiactividad(peligro) //Devuelve true or false
	
	method enfrentar(peligro){
		if(self.enfrentaPeligro(peligro)){
			estrategia += peligro.nivelComplejidad()		//Lo puede enfrentar y aumenta su estrategia
		}else{
			self.error("No puedo enfrentar este peligro!")
		}
	}
}

class Poder{
	method agilidad(personaje)	//C/u de estas caracteristicas se calculan utilizando
	method fuerza(personaje)	//valores del personaje y valores segun el tipo de poder.
	method habilidadEspecial(personaje)= return personaje.espiritualidad() + personaje.estrategia() //Solo poder amplificado lo va a cambiar
	
	method capacidadBatalla(personaje){
		return (self.agilidad(personaje) + self.fuerza(personaje)) * self.habilidadEspecial(personaje)
	}
	
	method inmuneRadiacion()
}

class Velocidad inherits Poder{
	var rapidez
	override method agilidad(personaje)= personaje.estrategia() * rapidez
	override method fuerza(personaje)= personaje.espiritualidad() * rapidez
	override method inmuneRadiacion() = false
}

class Vuelo inherits Poder{
	var alturaMax
	var energiaDespegue
	override method agilidad(personaje)= ( (personaje.estrategia() * alturaMax) / energiaDespegue )
	override method fuerza(personaje)= ( (personaje.espiritualidad() + alturaMax) - energiaDespegue )
	override method inmuneRadiacion() = alturaMax > 200
}

class PoderAmplificador inherits Poder{
	var poderBase
	var nroAmplificador
	override method agilidad(personaje)= return poderBase.agilidad(personaje)
	override method fuerza(personaje)= return poderBase.fuerza(personaje)
	override method habilidadEspecial(personaje)= return poderBase.habilidadEspecial(personaje) * nroAmplificador
	override method inmuneRadiacion() = true
}

/*
***********REQUERIMIENTOS PARTE 2***********
1) Saber cuál es el miembro mas vulnerable: el/la de capacidad de batalla menor
2) Saber la calidad del equipo: promedio de capacidades
3) Saber los mejores poderes: conjunto formado por el mejor poder de c/miembro.
							  El mejor poder es aquel que otorga mas cap. de batalla.
Resumen: equipo tambien es una clase que va a tener una lista de personajes y metodos para
c/u de los requerimientos, no mucho mas.
*/

/*
De un peligro se conoce la capacidad de batalla y si tiene desechos radioactivos.

Un personaje afronta un peligro solo si:
* Capacidad de batalla del personaje >>> capacidad batalla peligro
* Si puede manejar radioactividad ---> personaje inmune a radiacion. ----> Si el peligro NO es radiactivo, esta variable no importa
* 
====> El peligro puede ser afrontado por el grupo si c/u de los miembros puede
	  afrontarlo individualmente.
 
Un personaje es inmune a la radioactividad si tiene al menos un poder que se la de.
* Vuelo: otorga inmunidad si la alturaMax >> 200
* Velocidad: NUNCA
* Poder Amplificador: SIEMPRE
Agrego esa data a c/poder.

***********REQUERIMIENTOS PARTE 3***********
1) Saber si un personaje puede enfrentar un peligro
2) Saber si el equipo puede afrontar un peligro (sensato).
 
Resumen: para el 1) hay que agregar cosas a la clase de Personajes para saber si el personaje
puede afrontar al peligro, si es inmune, etc. Para el 2) hay que agregar a la clase
Equipo si pueden contra ese peligro tooodos los miembros.
Hace falta una clase de peligro con sus variables (capacidad, desechos). Hay varios casos de prueba.
*/

//Parte 2: equipo ////// Parte 3: peligros (consultas)

class Equipo{
	var miembros = []
	
	method miembroVulnerable()= miembros.min({miembro => miembro.capacidadBatalla()}) //.min() devuelve el de menor valor

	method calidadEquipo()= ( miembros.sum({miembro => miembro.capacidadBatalla()}) / miembros.size() ) //Devuelve solo el nro pero es buena o mala calidad segun qué criterio?
	
	//Todos los miembros tienen una lista de poderes. Basicamente hay que revisar esa lista para cada personaje del equipo.
	//Ya que TODOS tienen poderes y TODOS tienen un poder que es mejor que el resto, la logica para averiguar cuál es ese poder
	//podria estar directamente en la clase de Personajes dado que es algo compartido por TODOS. 
	//.map devuelve una lista.
	method mejoresPoderes()= miembros.map({miembro => miembro.mejorPoder()})
	
	method afrontaPeligro(peligro)= miembros.all({miembro => miembro.enfrentaPeligro(peligro)})
	
	//Filtro una lista de todos los personajes de un equipo que sí pueden enfrentar un peligro para poder pasarselo al metodo de 
	//peligro.ganaPeligro() para que comparando el .size() de esta lista contra la cantidad de gente que se banca se pueda saber
	//si el equipo va bien o mal.
	method filtradoEquipoQuePuedeEnfrentar(peligro)= miembros.filter({miembro => miembro.enfrentaPeligro(peligro)})
	
	method enfrentar(peligro){
		if(not peligro.ganaPeligro(self.filtradoEquipoQuePuedeEnfrentar(peligro))){ //Si lo puede enfrentar, c/personaje
			self.filtradoEquipoQuePuedeEnfrentar(peligro).forEach({miembro => miembro.enfrentar(peligro)})		//lo enfrenta por separado
		}else{
			self.error("El equipo no puede enfrentar este peligro!")
		}
	}
}

/*
***********REQUERIMIENTOS PARTE 4***********
1) Hacer que un personaje enfrente un peligro de manera individual
2) Hacer que un equipo enfrente un peligro
 
Resumen: se agregan esas 2 variables a Peligro. Cuando 1 personaje afronta
un peligro, su nivel de estrategia aumenta en la cantidad de ptos que tiene de complejidad
el peligro.
2 condiciones para enfrentarlo en equipo: que TODOS puedan y que superen a la cant de personajes que se banca el peligro
*/

class Peligro{
	var property capacidadBatalla = 0
	var property desechosRadiactivos = false //Valor por default
	
	var property nivelComplejidad = 0
	var property personajesQueSeBanca = 0
	
	method ganaPeligro(equipo)= personajesQueSeBanca > equipo.size()
}

/*
Parte 5
Metahumano:
* Cap batalla: doble que el de 1 personaje
* Siempre inmune
* Afronta un peligro -> incrementa estrategia e espiritualidad, ambos con el valor de complejidad del peligro


Mago: metahumano especial
* Tiene poder acumulado
* Cap batalla= igual-metahumano + poderAcumulado
* Afronta un peligro -> idem aumento estrategia+espiritualidad de metahumanos SI su poderAcumulado > 10
  Post: pierde 5 puntos de poderAcumulado. Si tenia - de 5 -> queda en cero.

*/
class Metahumano inherits Personaje{
	override method capacidadBatalla()= super() * 2
	override method inmuneRadiacion()= true
	override method enfrentar(peligro){
		super(peligro)
		espiritualidad += peligro.nivelComplejidad()
	}
}

class Mago inherits Metahumano{
	var property poderAcumulado
	override method capacidadBatalla()= super() + poderAcumulado
	override method enfrentar(peligro){
		if(poderAcumulado > 10){
			super(peligro)
			poderAcumulado -= 5 
		}
	}
}