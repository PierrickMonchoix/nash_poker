# Situation

*A* et *B* sont deux joueurs à qui sont respectivement attribués *force A* et *force B* compris entre 0 et 1.
A et B participent alors à un tour de pseudo poker où :
- La force d'un joueur équivaut à la force de ses cartes
- Un pot est déterminé au début du jeu
- A mise une somme *x* (on dit que A bet x) pouvant être nulle et B peut choisir entre call soit fold (pas de relance) il s'agit du *choix* de B
- Si, à l'abatage, force A est égal à force B alors B gagne

On cherche la stratégie de mise de A représentéte par 

$f_A : force\ A \mapsto x$

tel que :

$f_A = max_{f}(\sum_{i = force\ A} E_{A}[force\ A=i\ et \ A\ bet\ f(i)])$

On cherche aussi 

$f_B : force\ B, x \mapsto choix$

tel que : &amp;

$f_B(force\ B, x) = call\ ssi\ E_{B}[A\ bet\ x > 0]$


# Calcul de $f_A$

$E_{A}[force\ A\ \& A\ bet\ x] =                                      \\
\ \ \ \ (1 - P(B\ call \mid A\ bet\ x)) * pot                           \\
\ \ + P(B\ call \mid A\ bet\ x) * P(A\ win \mid B\ call) * (pot + bet)  \\
\ \ + P(B\ call \mid A\ bet\ x) * (1 - P(A\ win \mid B\ call)) * (-bet)$

Attention, ici, B call sous entend B call sachant que A bet x

$
E_{A}[force\ A\ \& A\ bet\ x] =                                                                   \\
\ \ \ \ (1 - P(f_B(x) == true)) * pot                           \\
\ \ + P(f_B(x) == true) * P(A\ win \mid f_B(x) == true) * (pot + bet)  \\
\ \ + P(f_B(x) == true) * (1 - P(A\ win \mid f_B(x) == true)) * (-bet)
$

$
E_{A}[force\ A\ \& A\ bet\ x] =                                                                   \\
\ \ \ \ (1 - P(f_B(x) == true)) * pot                           \\
\ \ + P(f_B(x) == true) * P(force\ A\ > force\ B\ |\ {force\ B} \in {\{F\ |\ f_B(F,x)=true\}}) * (pot + bet)  \\
\ \ + P(f_B(x) == true) * (1 - P(force\ A\ > force\ B\ |\ {force\ B} \in {\{F\ |\ f_B(F,x)=true\}})) * (-bet)
$

Rappel :

$f_A = max_{f}(\sum_{i = force\ A} E_{A}[force\ A=i\ \& A\ bet\ f(i)])$


# Calcul de $f_B$

$
E_{B}[B\ call] =                                           \\
            \ \ \ \ P(B\ win \mid A\ bet\ x) * (pot + bet) \\
            \ \ +(1 - P(B\ win \mid A\ bet\ x)) * (-bet)
$

$
E_{B}[B\ call] =                                           \\
            \ \ \ \ P(force\ B > force\ A | {force\ A} \in \{F\ |\ f_A(F)=x\}) * (pot + bet) \\
            \ \ +(1 - P(force\ B > force\ A | {force\ A} \in \{F\ |\ f_A(F)=x\})) * (-bet)
$

Rappel :

$f_B(force\ B, x) = true\ ssi\ E_{B}[A\ bet\ x] > 0$

# Résolution numérique

Le but est de trouver numériquement $f_A$ et $f_B$.
Pour ce faire, on suppose que $f_A$ = $f_{A,0}$ où $f_{A,0}$ est une fonction simple.
On détermine ensuite $f_B$ sous cette hypotèse.
Cela donne alors $f_{B,0}$. Puis on suppose que $f_B = f_{B,0}$ pour determiner $f_{A,1}$.

On procède ainsi de suite jusqu'a ce que $f_{A,n}$ = $f_{A,n-}$. L'équilibre de Nash de ce jeu sera alors trouvé.

--------------------------------------------------------------------

--------------------------------------------------------------------

--------------------------------------------------------------------







## Calcul de $P(A\ win \mid f_B(x) == true)$

$P(A\ win \mid f_B(x) == true) = P(A\ win \mid A\ bet\ x) * \frac{P(B\ call \mid A\ win)}{P(B\ call \mid A\ bet\ x)}$

Avec

- $P(A\ win \mid A\ bet\ x)$ proba récursive connaisant $f_a$
- $P(B\ call \mid A\ bet\ x)$ calculée au dessus
- $P(B\ call \mid A\ win)$ TODO









------------------------------
## Calcul de $P(B\ call \mid A\ bet\ x)$

$
P(B\ call \mid A\ bet\ x) = P(E_{B}[B\ call]>0)
$

Or 

$
E_{B}[B\ call] =                                           \\
            \ \ \ \ P(B\ win \mid A\ bet\ x) * (pot + bet) \\
            \ \ +(1 - P(B\ win \mid A\ bet\ x)) * (-bet)
$

Or

$
P(B\ win \mid A\ bet\ x) = P(B\ win) * \frac{P(A\ bet\ x \mid B\ win)}{P(A\ bet\ x)}
$

D'où

$
P(B\ call \mid A\ bet\ x) = P(P(B\ win) * \frac{P(A\ bet\ x \mid B\ win)}{P(A\ bet\ x)} * (pot + bet) + (1 - P(B\ win) * \frac{P(A\ bet\ x \mid B\ win)}{P(A\ bet\ x)}) * (-bet) > 0)
$

Avec

- $P(B\ win)$ proba a priori
- $P(A\ bet\ x)$ proba récursive connaisant $f_a$
- $P(A\ bet\ x \mid B\ win)$ proba récursive connaisant $f_a$ et que la range de A est retrainte par B win

## Calcul de $P(A\ win \mid B\ call)$

$P(A\ win \mid B\ call) = P(A\ win \mid A\ bet\ x) * \frac{P(B\ call \mid A\ win)}{P(B\ call \mid A\ bet\ x)}$

Avec

- $P(A\ win \mid A\ bet\ x)$ proba récursive connaisant $f_a$
- $P(B\ call \mid A\ bet\ x)$ calculée au dessus
- $P(B\ call \mid A\ win)$ TODO

## Formule finale





# Situation

*A* et *B* sont deux joueurs.

A mise (on dit que A bet x) (la mise peut être nulle) et B peut soit call soit fold.

A cherche $f_A : force\ A \mapsto x$ tel que :

$max_{f_A}(\sum_{i = force\ A} E_{A}[A\ bet\ f_A(i)])$ est atteint

A mise x ssi l'espérence de A $E_{A}$ vaut $max_{x}(E_{A}[A\ bet\ x])$

# Calcul de $E_{A}[A\ bet\ x]$

## Formule initiale

$
E_{A}[A\ bet\ x] =                                                                  \\
            \ \ \ \ (1 - P(B\ call \mid A\ bet\ x)) * pot                           \\
            \ \ + P(B\ call \mid A\ bet\ x) * P(A\ win \mid B\ call) * (pot + bet)  \\
            \ \ + P(B\ call \mid A\ bet\ x) * (1 - P(A\ win \mid B\ call)) * (-bet)
$

Attention, ici, B call sous entend B call sachant que A bet x

## Calcul de $P(B\ call \mid A\ bet\ x)$

$
P(B\ call \mid A\ bet\ x) = P(E_{B}[B\ call]>0)
$

Or 

$
E_{B}[B\ call] =                                           \\
            \ \ \ \ P(B\ win \mid A\ bet\ x) * (pot + bet) \\
            \ \ +(1 - P(B\ win \mid A\ bet\ x)) * (-bet)
$

Or

$
P(B\ win \mid A\ bet\ x) = P(B\ win) * \frac{P(A\ bet\ x \mid B\ win)}{P(A\ bet\ x)}
$

D'où

$
P(B\ call \mid A\ bet\ x) = P(P(B\ win) * \frac{P(A\ bet\ x \mid B\ win)}{P(A\ bet\ x)} * (pot + bet) + (1 - P(B\ win) * \frac{P(A\ bet\ x \mid B\ win)}{P(A\ bet\ x)}) * (-bet) > 0)
$

Avec

- $P(B\ win)$ proba a priori
- $P(A\ bet\ x)$ proba récursive connaisant $f_a$
- $P(A\ bet\ x \mid B\ win)$ proba récursive connaisant $f_a$ et que la range de A est retrainte par B win

## Calcul de $P(A\ win \mid B\ call)$

$P(A\ win \mid B\ call) = P(A\ win \mid A\ bet\ x) * \frac{P(B\ call \mid A\ win)}{P(B\ call \mid A\ bet\ x)}$

Avec

- $P(A\ win \mid A\ bet\ x)$ proba récursive connaisant $f_a$
- $P(B\ call \mid A\ bet\ x)$ calculée au dessus
- $P(B\ call \mid A\ win)$ TODO

## Formule finale

