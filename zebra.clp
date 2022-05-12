(deffacts init
	(colors		piros zold kek elefantcsont sarga)
	(nations	angol spanyol norveg ukran japan)
	(pets		kutya csiga roka lo zebra)
	(cars		Oldsmobile Chevrolet Ford Mercedes Volkswagen)
	(drinks		tojaslikor kakao tej narancsle viz)
	(houses		1 2 3 4 5))

(defrule generate-colors
	(colors $? ?c $?)
	(houses $? ?h $?)
	=>
	(assert (color-is ?c ?h))
)

(defrule generate-nations
	(nations	$? ?n $?)
	(houses		$? ?h $?)
	=>
	(assert (nation-is ?n ?h))
)

(defrule generate-ptes
	(pets		$? ?p $?)
	(houses		$? ?h $?)
	=>
	(assert (pet-is ?p ?h))
)

(defrule generate-cars
	(cars		$? ?c $?)
	(houses		$? ?h $?)
	=>	
	(assert (car-is ?c ?h))
)

(defrule generate-drinks
	(drinks		$? ?d $?)
	(houses		$? ?h $?)
	=>
	(assert (drink-is	?d ?h))
)

(defrule solve
	; Az angol a piros házban lakik
	(nation-is angol ?ANGOL)
	(color-is piros ?PIROS&?ANGOL)
	; A spanyolnak van egy kutyája
	(nation-is spanyol ?SPANYOL&~?ANGOL)
	(pet-is kutya ?KUTYA&?SPANYOL)
	(test (not (= ?SPANYOL ?ANGOL)))
	(test (= ?KUTYA ?SPANYOL))
	; Kakaót a zöld házban isznak
	(drink-is kakao ?KAKAO)
	(color-is zold ?ZOLD&?KAKAO&~?PIROS)
	; Az ukrán tojáslikőrt iszik
	(nation-is ukran ?UKRAN&~?ANGOL&~?SPANYOL)
	(drink-is tojaslikor ?TOJASLIKOR&~?KAKAO&?UKRAN)
	; A zöld ház az elefántcsontszínű mellett van
	(color-is elefantcsont ?ELEFANTCSONT&~?PIROS&~?ZOLD)
	(test (or (= ?ELEFANTCSONT (+ 1 ?ZOLD)) (= ?ZOLD (+ 1 ?ELEFANTCSONT))))
	; Az Oldsmobile tulajdonosának csigái vannak
	(car-is Oldsmobile ?OLDSMOBILE)
	(pet-is csiga ?CSIGA&~?KUTYA&?OLDSMOBILE)
	; A Ford tulajdonosa a sárga házban lakik
	(car-is Ford ?FORD&~?OLDSMOBILE)
	(color-is sarga ?SARGA&~?ELEFANTCSONT&~?ZOLD&~?PIROS&?FORD)
	; Tejet a középső házban isznak
	(drink-is tej ?TEJ&3&~?TOJASLIKOR&~?KAKAO)
	; A norvég balról az első házban lakik
	(nation-is norveg ?NORVEG&1&~?UKRAN&~?ANGOL&~?SPANYOL)
	; A Chevrolet tulajdonos szomszédjának rókája van
	(car-is Chevrolet ?CHEVROLET&~?OLDSMOBILE&~?FORD)
	(pet-is roka ?ROKA&~?CSIGA&~?KUTYA)
	(test (or (= ?ROKA (+ 1 ?CHEVROLET)) (= ?CHEVROLET (+ 1 ?ROKA)) ))
	; A lótulajdonos szomszédja Ford márkájú autót vezet
	(pet-is lo ?LO&~?ROKA&~?CSIGA&~?KUTYA)
	(test (or (= ?LO (+ 1 ?FORD)) (= ?FORD (+ 1 ?LO))))
	; A Mercedes gazdája narancsleve iszik
	(car-is Mercedes ?MERCEDES&~?CHEVROLET&~?OLDSMOBILE&~?FORD)
	(drink-is narancsle ?NARANCSLE&?MERCEDES&~?TEJ&~?TOJASLIKOR&~?KAKAO)
	; A japán Volkswagen-t vezet
	(nation-is japan ?JAPAN&~?NORVEG&~?UKRAN&~?ANGOL&~?SPANYOL)
	(car-is Volkswagen ?VOLKSWAGEN&?JAPAN&~?MERCEDES&~?OLDSMOBILE&~?FORD&~?CHEVROLET)
	; A norvég a kék ház mellett lakik
	(color-is kek ?KEK&~?SARGA&~?ELEFANTCSONT&~?ZOLD&~?PIROS)
	(test (or (= ?KEK (+ 1 ?NORVEG)) (= ?NORVEG (+ 1 ?KEK))))
	; Hol isznak vizet?
	(drink-is viz ?VIZ&~?NARANCSLE&~?TEJ&~?KAKAO&~?TOJASLIKOR)
	; Kié a zebra?
	(pet-is zebra ?ZEBRA&~?ROKA&~?KUTYA&~?CSIGA&~?LO)
	;
	(or
		(nation-is ?NATION&angol ?ZEBRA&?ANGOL)
		(nation-is ?NATION&spanyol ?ZEBRA&?SPANYOL)
		(nation-is ?NATION&norveg ?ZEBRA&?NORVEG)
		(nation-is ?NATION&ukran ?ZEBRA&?UKRAN)
		(nation-is ?NATION&japan ?ZEBRA&?JAPAN)
	)
	=>
	(assert (solution zebra ?NATION viz ?VIZ))
	(printout t ?NATION)
)



