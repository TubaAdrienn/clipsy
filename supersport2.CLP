(deffacts init
	(men            aladar balint elemer henrik marton)
	(wives          amalia blanka eszter hedvig margit)
	(sports	        siugras evezes uszas magasugras futas)
	(professions    tanar festo zenesz kertesz postas)
	(husbands		1 2 3 4 5))

(defrule generate-men
	(men $? ?m $?)
	(husbands $? ?h $?)
	=>
	(assert (man-is ?m ?h))
)

(defrule generate-sports
	(sports	$? ?s $?)
	(husbands $? ?h $?)
	=>
	(assert (sport-is ?s ?h))
)

(defrule generate-professions
	(professions $? ?p $?)
	(husbands $? ?h $?)
	=>	
	(assert (profession-is ?p ?h))
)

(defrule generate-wives
	(wives $? ?w $?)
	(husbands $? ?h $?)
	=>
	(assert (wife-is ?w ?h))
)

(defrule solve
    ;Aladár felesége síugró világbajnok
    (man-is aladar ?ALADAR)
    (sport-is siugras ?SIUGRAS&?ALADAR)
    ;A postás (nem Aladár) felesége (Hedvig) nem evezőversenyzik.
    (profession-is postas ?POSTAS&~?ALADAR)
    (sport-is evezes ?EVEZES&~?SIUGRAS)
    (wife-is hedvig ?HEDVIG&?POSTAS&~?EVEZES)
    ; Elemér felesége Eszter.
    (man-is elemer ?ELEMER&~?ALADAR)
    (wife-is eszter ?ESZTER&?ELEMER&~?HEDVIG)
    ;Amália úszik. Bálint festő. Amália férje festő, nem Bálint.
    (sport-is uszas ?USZAS&~?SIUGRAS&~?EVEZES)
    (profession-is festo ?FESTO&~?POSTAS)
    (wife-is amalia ?AMALIA&?USZAS&~?ESZTER&~?HEDVIG)
    (man-is balint ?BALINT&~?ALADAR&?FESTO&~?ELEMER&~?AMALIA)
    ; Margit férje nem festő.
    (wife-is margit ?MARGIT&~?HEDVIG&~?ESZTER&~?AMALIA&~?FESTO)
    ; A zenész felesége magasugró.
    (sport-is magasugras ?MAGASUGRAS&~?SIUGRAS&~?EVEZES&~?USZAS)
    (profession-is zenesz ?ZENESZ&?MAGASUGRAS&~?POSTAS&~?FESTO)
    ; Márton neje nem úszó és nem magasugró.
    (man-is marton ?MARTON&~?ALADAR&~?ELEMER&~?BALINT&~?USZAS&~?MAGASUGRAS)
    ; Henrik nem tanár.
    ; Henrik felesége nem Blanka.
    (wife-is blanka ?BLANKA&~?HEDVIG&~?ESZTER&~?AMALIA&~?MARGIT)
    (profession-is tanar ?TANAR&~?POSTAS&~?FESTO&~?ZENESZ)
    (man-is henrik ?HENRIK&~?ALADAR&~?ELEMER&~?BALINT&~?MARTON&~?TANAR&~?BLANKA)
    ;Kertész neve mássalhangzóval kezdődik
	(or
		(profession-is kertesz ?KERTESZ&~?TANAR&~?POSTAS&~?FESTO&~?ZENESZ&~?ALADAR)
		(profession-is kertesz ?KERTESZ&~?TANAR&~?POSTAS&~?FESTO&~?ZENESZ&~?ELEMER)
	)
	(test (not (= ?KERTESZ ?ALADAR)))
    (test (not (= ?KERTESZ ?ELEMER)))
    ; A futónőnek és a férjének más a nevük kezdőbetűje.
    (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS)
    (or
		(not (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS&?AMALIA&?ALADAR))
		(not (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS&?ELEMER&?ESZTER))
		(not (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS&?HENRIK&?HEDVIG))
		(not (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS&?MARGIT&?MARTON))
		(not (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS&?BALINT&?BLANKA))
	)
	(test (not (and (= ?FUTAS ?AMALIA) (= ?FUTAS ?ALADAR))))
    (test (not (and (= ?FUTAS ?BALINT) (= ?FUTAS ?BLANKA))))
    (test (not (and (= ?FUTAS ?ESZTER) (= ?FUTAS ?ELEMER))))
    (test (not (and (= ?FUTAS ?HENRIK) (= ?FUTAS ?HENRIK))))
    (test (not (and (= ?FUTAS ?MARGIT) (= ?FUTAS ?MARTON))))
	(or
		(wife-is ?WIFE&amalia ?ALADAR&?AMALIA)
		(wife-is ?WIFE&blanka ?ALADAR&?BLANKA)
		(wife-is ?WIFE&eszter ?ALADAR&?ESZTER)
		(wife-is ?WIFE&hedvig ?ALADAR&?HEDVIG)
		(wife-is ?WIFE&margit ?ALADAR&?MARGIT)
	)
	=>
	(assert  (solution Aladar ?WIFE))
	(printout t ?WIFE)
)

