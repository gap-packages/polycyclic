PrintCollector := function( coll )

    local   number_of_gens,
            gens,
            inverses,
            commute,
            powers,
            inverse_powers,
            exponents,
            conjugates,
            inverse_conj,
            conj_inverse,
            inv_conj_inv,
            commutators,
            inv_commutators,
            commutators_inv,
            inv_comm_inv,
            deep_thought,
            all;

    number_of_gens  := coll![ PC_NUMBER_OF_GENERATORS ];
    gens            := coll![ PC_GENERATORS ];
    inverses        := coll![ PC_INVERSES ];
    commute         := coll![ PC_COMMUTE ];
    powers          := coll![ PC_POWERS ];
    inverse_powers  := coll![ PC_INVERSEPOWERS ];
    exponents       := coll![ PC_EXPONENTS ];
    conjugates      := coll![ PC_CONJUGATES ];
    inverse_conj    := coll![ PC_INVERSECONJUGATES ];
    conj_inverse    := coll![ PC_CONJUGATESINVERSE ];
    inv_conj_inv    := coll![ PC_INVERSECONJUGATESINVERSE ];

    commutators     := coll![ PC_COMMUTATORS ];
    inv_commutators := coll![ PC_INVERSECOMMUTATORS ];
    commutators_inv := coll![ PC_COMMUTATORSINVERSE ];
    inv_comm_inv    := coll![ PC_INVERSECOMMUTATORSINVERSE ];

    deep_thought    := coll![ PC_DEEP_THOUGHT_POLS ];

    all := [    number_of_gens,
                gens,
                inverses,
                commute,
                powers,
                inverse_powers,
                exponents,
                conjugates,
                inverse_conj,
                conj_inverse,
                inv_conj_inv,
                commutators,
                inv_commutators,
                commutators_inv,
                inv_comm_inv];

    return rec( number_of_gens := number_of_gens,
                gens := gens,
                inverses := inverses,
                commute := commute,
                powers := powers,
                inverse_powers := inverse_powers,
                exponents := exponents,
                conjugates := conjugates,
                inverse_conj := inverse_conj,
                conj_inverse := conj_inverse,
                inv_conj_inv := inv_conj_inv,
                commutators := commutators,
                inv_commutators := inv_commutators,
                commutators_inv := commutators_inv,
                inv_comm_inv := inv_comm_inv,
                deep_thought := deep_thought,
                all := all );

end;
