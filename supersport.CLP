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
	(husbands $? ?h $?)
	(or
		(wife-is ?WIFE&amalia ?AMALIA&?h)
		(wife-is ?WIFE&blanka ?BLANKA&?h)
		(wife-is ?WIFE&eszter ?ESZTER&?h)
		(wife-is ?WIFE&hedvig ?HEDVIG&?h)
		(wife-is ?WIFE&margit ?MARGIT&?h)
	)
	(or
		(man-is ?HUSBAND&aladar ?ALADAR&?h)
		(man-is ?HUSBAND&balint ?BALINT&?h)
		(man-is ?HUSBAND&elemer ?ELEMER&?h)
		(man-is ?HUSBAND&marton ?MARTON&?h)
		(man-is ?HUSBAND&henrik ?HENRIK&?h)
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
	(assert (solution ?HUSBAND ?WIFE ?PROFESSION ?SPORT))
)

