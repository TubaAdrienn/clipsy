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
    (profession-is kertesz ?KERTESZ&~?TANAR&~?POSTAS&~?FESTO&~?ZENESZ)
    (test (not (= ?KERTESZ ?ALADAR)))
    (test (not (= ?KERTESZ ?ELEMER)))
    ; A futónőnek és a férjének más a nevük kezdőbetűje.
    (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS)
    (test (not (and (= ?FUTAS ?AMALIA) (= ?FUTAS ?ALADAR))))
    (test (not (and (= ?FUTAS ?BALINT) (= ?FUTAS ?BLANKA))))
    (test (not (and (= ?FUTAS ?ESZTER) (= ?FUTAS ?ELEMER))))
    (test (not (and (= ?FUTAS ?HENRIK) (= ?FUTAS ?HENRIK))))
    (test (not (and (= ?FUTAS ?MARGIT) (= ?FUTAS ?MARTON))))
    ;Fuck around and find out
    (or
		(wife-is ?WIFE_ALADAR&amalia ?ALADAR&?AMALIA)
		(wife-is ?WIFE_ALADAR&blanka ?ALADAR&?BLANKA)
		(wife-is ?WIFE_ALADAR&eszter ?ALADAR&?ESZTER)
		(wife-is ?WIFE_ALADAR&hedvig ?ALADAR&?HEDVIG)
		(wife-is ?WIFE_ALADAR&margit ?ALADAR&?MARGIT)
	)
    (or
		(wife-is ?WIFE_BALINT&amalia ?BALINT&?AMALIA)
		(wife-is ?WIFE_BALINT&blanka ?BALINT&?BLANKA)
		(wife-is ?WIFE_BALINT&eszter ?BALINT&?ESZTER)
		(wife-is ?WIFE_BALINT&hedvig ?BALINT&?HEDVIG)
		(wife-is ?WIFE_BALINT&margit ?BALINT&?MARGIT)
	)
    (or
		(wife-is ?WIFE_ELEMER&amalia ?ELEMER&?AMALIA)
		(wife-is ?WIFE_ELEMER&blanka ?ELEMER&?BLANKA)
		(wife-is ?WIFE_ELEMER&eszter ?ELEMER&?ESZTER)
		(wife-is ?WIFE_ELEMER&hedvig ?ELEMER&?HEDVIG)
		(wife-is ?WIFE_ELEMER&margit ?ELEMER&?MARGIT)
	)
    (or
		(wife-is ?WIFE_MARTON&amalia ?MARTON&?AMALIA)
		(wife-is ?WIFE_MARTON&blanka ?MARTON&?BLANKA)
		(wife-is ?WIFE_MARTON&eszter ?MARTON&?ESZTER)
		(wife-is ?WIFE_MARTON&hedvig ?MARTON&?HEDVIG)
		(wife-is ?WIFE_MARTON&margit ?MARTON&?MARGIT)
	)
    (or
		(wife-is ?WIFE_HENRIK&amalia ?HENRIK&?AMALIA)
		(wife-is ?WIFE_HENRIK&blanka ?HENRIK&?BLANKA)
		(wife-is ?WIFE_HENRIK&eszter ?HENRIK&?ESZTER)
		(wife-is ?WIFE_HENRIK&hedvig ?HENRIK&?HEDVIG)
		(wife-is ?WIFE_HENRIK&margit ?HENRIK&?MARGIT)
	)
    =>
    (assert (solution Aladar ?WIFE_ALADAR))
    (assert (solution Balint ?WIFE_BALINT))
    (assert (solution Elemer ?WIFE_ELEMER))
    (assert (solution Henrik ?WIFE_HENRIK))
    (assert (solution Marton ?WIFE_MARTON))
	(printout t ?WIFE_ALADAR)
)

;Aladar blanka
;Aladar Margit

;Balint Amalia
;Balint margit
;Balint blanka
;Balint Hedvig

;Elemer Eszter

;Henrik Margit
;Henrik Amalia

;Marton Hedvig
;Marton Margit
;Marton Blanka