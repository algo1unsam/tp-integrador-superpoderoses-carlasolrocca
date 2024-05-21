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

//Parte 1
class Personaje{
	var property espiritualidad
	var property estrategia
	const poderes = []
	
	//E capacidades de batalla de sus poderes adecuado a c/personaje
	method capacidadBatalla(){
		poderes.sum( {poder => poder.capacidadBatalla(self)} )
	}
}

class Poder{
	method agilidad(personaje)	//C/u de estas caracteristicas se calculan utilizando
	method fuerza(personaje)	//valores del personaje y valores segun el tipo de poder.
	method habilidadEspecial(personaje)= personaje.espiritualidad() + personaje.estrategia() //Solo poder amplificado lo va a cambiar
	
	method capacidadBatalla(personaje){
		( self.agilidad(personaje) + self.fuerza(personaje) ) * self.habilidadEspecial(personaje)
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
	override method agilidad(personaje)= poderBase.agilidad(personaje)
	override method fuerza(personaje)= poderBase.fuerza(personaje)
	override method habilidadEspecial(personaje)= poderBase.habilidadEspecial(personaje) * nroAmplificador
}






































