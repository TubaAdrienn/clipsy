(deffacts init
	(husbands            aladar balint elemer henrik marton)
	(wives          amalia blanka eszter hedvig margit)
	(sports	        siugras evezes uszas magasugras futas)
	(professions    tanar festo zenesz kertesz postas)
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
    (sport-is siugras ?SIUGRAS&aladar)
    ;A postás (nem Aladár) felesége (Hedvig) nem evezőversenyzik.
    (profession-is postas ?POSTAS&~aladar)
    (sport-is evezes ?EVEZES&~?SIUGRAS)
    (wife-is hedvig ?HEDVIG&?POSTAS&~?EVEZES)
    ;(test (not (eq ?HEDVIG aladar)))
    ; Elemér felesége Eszter.
    (wife-is eszter ?ESZTER&elemer&~?HEDVIG)
    ;Amália úszik. Bálint festő. Amália férje festő, nem Bálint.
    (sport-is uszas ?USZAS&~?SIUGRAS&~?EVEZES)
    (profession-is festo ?FESTO&~?POSTAS&balint)
    (wife-is amalia ?AMALIA&?USZAS&~?ESZTER&~?HEDVIG&~balint)
    ; Margit férje nem festő.
    (wife-is margit ?MARGIT&~?HEDVIG&~?ESZTER&~?AMALIA&~?FESTO)
    ; A zenész felesége magasugró.
    (sport-is magasugras ?MAGASUGRAS&~?SIUGRAS&~?EVEZES&~?USZAS)
    (profession-is zenesz ?ZENESZ&?MAGASUGRAS&~?POSTAS&~?FESTO)
    ; Márton neje nem úszó és nem magasugró.
    (test (not (eq marton ?USZAS)))
    (test (not (eq marton ?MAGASUGRAS)))
    ; Henrik nem tanár.
    ; Henrik felesége nem Blanka.
    (wife-is blanka ?BLANKA&~?HEDVIG&~?ESZTER&~?AMALIA&~?MARGIT&~henrik)
    (profession-is tanar ?TANAR&~?POSTAS&~?FESTO&~?ZENESZ&~henrik)
    ;Kertész neve mássalhangzóval kezdődik
	(or
		(profession-is kertesz ?KERTESZ&~?TANAR&~?POSTAS&~?FESTO&~?ZENESZ&~aladar)
		(profession-is kertesz ?KERTESZ&~?TANAR&~?POSTAS&~?FESTO&~?ZENESZ&~elemer)
	)
	;(test (not (eq ?KERTESZ aladar)))
    ;(test (not (eq ?KERTESZ elemer)))
    ; A futónőnek és a férjének más a nevük kezdőbetűje.
    (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS)
    ;(or
	;	(not (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS&?AMALIA&aladar))
	;	(not (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS&elemer&?ESZTER))
	;	(not (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS&henrik&?HEDVIG))
	;	(not (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS&?MARGIT&marton))
	;	(not (sport-is futas ?FUTAS&~?SIUGRAS&~?EVEZES&~?USZAS&~?MAGASUGRAS&balint&?BLANKA))
	;)
    (test (not (and (eq ?FUTAS ?AMALIA) (eq ?FUTAS aladar))))
    (test (not (and (eq ?FUTAS ?BLANKA) (eq ?FUTAS balint))))
    (test (not (and (eq ?FUTAS ?ESZTER) (eq ?FUTAS elemer))))
    (test (not (and (eq ?FUTAS ?HEDVIG) (eq ?FUTAS henrik))))
    (test (not (and (eq ?FUTAS ?MARGIT) (eq ?FUTAS marton))))
    (husbands $? ?h $?)
    (or
		(wife-is ?WIFE&amalia ?AMALIA&?h)
		(wife-is ?WIFE&blanka ?BLANKA&?h)
		(wife-is ?WIFE&eszter ?ESZTER&?h)
		(wife-is ?WIFE&hedvig ?HEDVIG&?h)
		(wife-is ?WIFE&margit ?MARGIT&?h)
	)
    (or
		(profession-is ?PROFESSION&tanar ?TANAR&?h)
		(profession-is ?PROFESSION&festo ?FESTO&?h)
		(profession-is ?PROFESSION&zenesz ?ZENESZ&?h)
		(profession-is ?PROFESSION&kertesz ?KERTESZ&?h)
		(profession-is ?PROFESSION&postas ?POSTAS&?h)
	)
    (or
		(sport-is ?SPORT&siugras ?SIUGRAS&?h)
		(sport-is ?SPORT&evezes ?EVEZES&?h)
		(sport-is ?SPORT&uszas ?USZAS&?h)
		(sport-is ?SPORT&magasugras ?MAGASUGRAS&?h)
		(sport-is ?SPORT&futas ?FUTAS&?h)
	)
	=>	
    (assert (solution ?h ?WIFE ?PROFESSION ?SPORT))
    (printout t ?WIFE )
)

