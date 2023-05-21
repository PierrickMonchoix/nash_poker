# Situation

*A* et *B* sont deux joueurs à qui sont respectivement attribués *str A* et *str B* compris entre 0 et 1.
A et B participent alors à un tour de pseudo poker où :
- La force *str* d'un joueur équivaut à la force de la valeur de ses cartes
- Un pot *pot* est déterminé au début du jeu
- A mise une somme *x* (on dit que A bet x) pouvant être nulle et B peut choisir entre call soit fold (pas de relance possible) il s'agit du *choix* de B
- Si, à l'abatage, str A est égal à str B alors B gagne

On cherche la stratégie de mise de A représentéte par 

$f_A : str\ A \mapsto x$

tel que en moyenne, A gagne de l'argent sur au global (en moyenne sur les str A équiprobables), i.e tel que :

$f_A\ |\ max_{f_A}(\sum_{str\ A} E_{A}[str\ A,\ x])\ est\ atteint$

Avec :

$x = f_A(str\ A)$

On cherche aussi 

$f_B : (str\ B, x) \mapsto choix$

tel que en moyenne, B gagne de l'argent sur au global, i.e tel que :

$f_B\ |\ max_{f_B}(\sum_{str\ B}\sum_{str\ x} freq(x)*E_{B}[str\ B,\ x,\ choix])\ est\ atteint$

Avec :

$freq(x) = freq(f_A^{-1}(x))$

$choix = f_B(str\ B,\ x)$

# Calcul de $E_{A}$ en fonction de $f_B$

$E_{A}[str\ A,\ x] =$
$(1 - P(B\ call \mid A\ bet\ x)) * pot$
$+ P(B\ call \mid A\ bet\ x) * P(A\ win \mid B\ call) * (pot + bet)$
$+ P(B\ call \mid A\ bet\ x) * (1 - P(A\ win \mid B\ call)) * (-bet)$

Attention, ici, B call sous entend B call sachant que A bet x

$E_{A}[str\ A,\ x] =$
$(1 - P(f_B(x) = call)) * pot$
$+ P(f_B(x) = call) * P(A\ win \mid f_B(x) = call) * (pot + bet)$
$+ P(f_B(x) = call) * (1 - P(A\ win \mid f_B(x) = call)) * (-bet)$

$E_{A}[str\ A,\ x] =$
$(1 - P(f_B(x) = call)) * pot$
$+ P(f_B(x) = call) * P(str\ A\ > str\ B\ |\ {str\ B} \in {\{s\ |\ f_B(s,x)=call\}}) * (pot + bet)$
$+ P(f_B(x) = call) * (1 - P(str\ A\ > str\ B\ |\ {str\ B} \in {\{s\ |\ f_B(s,x)=call\}})) * (-bet)$

# Calcul de $E_{B}$ en fonction de $f_A$

$E_{B}[str\ B,\ x,\ choix] = \begin{cases} 
Si\ choix = call\ :\ P(B\ win \mid A\ bet\ x) * (pot + bet) + (1 - P(B\ win \mid A\ bet\ x)) * (-bet)\\\\
Si\ choix = fold\ :\ 0 \end{cases}$

$E_{B}[str\ B,\ x,\ choix] = \begin{cases} 
Si\ choix = call\ :\ P(str\ B \geq str\ A\ |\ {str\ A} \in \{s\ |\ f_A(s)=x\}) * (pot + bet) + (1 - P(str\ B \geq str\ A\ |\ {str\ A} \in \{s\ |\ f_A(s)=x\})) * (-bet)\\\\
Si\ choix = fold\ :\ 0 \end{cases}$

----

# Résolution numérique

Le but est de trouver numériquement $f_A$ et $f_B$.
Pour ce faire, on suppose que $f_A$ = $f_{A,0}$ où $f_{A,0}$ est une fonction simple.
On détermine ensuite $f_B$ sous cette hypotèse.
Cela donne alors $f_{B,0}$. Puis on suppose que $f_B = f_{B,0}$ pour determiner $f_{A,1}$.

On procède ainsi de suite jusqu'a ce que $f_{A,n}$ = $f_{A,n-1}$. L'équilibre de Nash de ce jeu sera alors trouvé.