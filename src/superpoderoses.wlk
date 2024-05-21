/*
Personaje
-estrategia y espiritualidad son dos caracteristicas (val numerico).
-tienen asociados varios poderes
-la rapidez es otra caracteristica? ---> no, solo se menciona en velocidad. es de ese poder.
-cap. de batalla del personaje: E capacidades que aportan sus poderes


Tipos de poderes:

----cap. de batalla de 1 poder: (agilidad + fuerza) * habilidadEspecial 
esas 3 cosas se ***CALCULAN*** para el personaje, el calculo de capBatalla
se mantiene pero varian esas 3 cosas.

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
}

class Poder{
	method agilidad(personaje)	//C/u de estas caracteristicas se calculan utilizando
	method fuerza(personaje)	//valores del personaje y valores segun el tipo de poder.
	method habilidadEspecial(personaje)= return personaje.espiritualidad() + personaje.estrategia() //Solo poder amplificado lo va a cambiar
	
	method capacidadBatalla(personaje){
		return (self.agilidad(personaje) + self.fuerza(personaje)) * self.habilidadEspecial(personaje)
	}
}

class Velocidad inherits Poder{
	var rapidez
	override method agilidad(personaje)= personaje.estrategia() * rapidez
	override method fuerza(personaje)= personaje.espiritualidad() * rapidez
}

class Vuelo inherits Poder{
	var alturaMax
	var energiaDespegue
	override method agilidad(personaje)= ( (personaje.estrategia() * alturaMax) / energiaDespegue )
	override method fuerza(personaje)= ( (personaje.espiritualidad() + alturaMax) - energiaDespegue )
}

class PoderAmplificador inherits Poder{
	var poderBase
	var nroAmplificador
	override method agilidad(personaje)= return poderBase.agilidad(personaje)
	override method fuerza(personaje)= return poderBase.fuerza(personaje)
	override method habilidadEspecial(personaje)= return poderBase.habilidadEspecial(personaje) * nroAmplificador
}

/*
Un equipo lo forman varios personajes.

***********REQUERIMIENTOS PARTE 2***********
1) Saber cuál es el miembro mas vulnerable: el/la de capacidad de batalla menor
2) Saber la calidad del equipo: promedio de capacidades
3) Saber los mejores poderes: conjunto formado por el mejor poder de c/miembro.
							  El mejor poder es aquel que otorga mas cap. de batalla.
Resumen: equipo tambien es una clase que va a tener una lista de personajes y metodos para
c/u de los requerimientos, no mucho mas.
*/


//Parte 2: equipo

class Equipo{
	var miembros = []
	
	method miembroVulnerable()= miembros.min({miembro => miembro.capacidadBatalla()}) //.min() devuelve el de menor valor

	method calidadEquipo()= ( miembros.sum({miembro => miembro.capacidadBatalla()}) / miembros.size() ) //Devuelve solo el nro pero es buena o mala calidad segun qué criterio?
	
	//Todos los miembros tienen una lista de poderes. Basicamente hay que revisar esa lista para cada personaje del equipo.
	//Ya que TODOS tienen poderes y TODOS tienen un poder que es mejor que el resto, la logica para averiguar cuál es ese poder
	//podria estar directamente en la clase de Personajes dado que es algo compartido por TODOS. 
	//.map devuelve una lista.
	method mejoresPoderes()= miembros.map({miembro => miembro.mejorPoder()})
}




