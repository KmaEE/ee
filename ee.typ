#show par: set block(spacing: 1.5em)
#set par(
  justify: true,
  leading: 0.75em
)


= How can elliptic curves be used to establish a shared secret over an insecure channel?

#pagebreak()

#outline()

#pagebreak()

== Introduction
// TODO cite
Internet connections and data go through Internet Service Providers (ISP) which snoop on users' information. [citation needed] An often used method to prevent eavesdropping is through TLS, commonly known as the green padlock next to the address bar or HTTPS, [citation needed] which establishes a secure connection between the user and the website that they are connecting to, such that the ISP only knows which website they have connected to but does not know the content that the user has downloaded or uploaded.

TLS has many different cryptographic techniques to establishing a secure connection. One of which is the Elliptic Curve Diffie-Hellman (ECDH). In this paper, we will examine the mathematical theory underlying the ECDH operation and evaluate its practical application in cybersecurity.

== The Discrete Log Problem in $ZZ_p^times$

As a consequence of Fermat's Little Theorem, we can write:
// todo spacing
$
a^(p-1) equiv 1 " " (mod p)\
a dot a^(p-2) equiv 1 " " (mod p)
$

// TODO cite
For any integer $a$ and prime $p$. We have found $a^(p-2)$ as $a$'s multiplicative inverse, therefore integers modulo $p$ with multiplication forms a group, as the operation is associative, has an identity element, and every element has an inverse. This group is represented with the symbol $(ZZ \/ p ZZ)^times$.

Given $a$ and $b$ are non-zero integers from this group, the discrete log problem asks us to find $k$ such that

$
a^k equiv b " " (mod p)
$

The assumption is that this problem is difficult to compute if the group and the exponent are well-chosen. This is used as the _trapdoor function_ in cryptography, as it is assumed to be easy to compute in one direction and hard to compute in the other. We'll evaluate the extent to which this claim is true for $(ZZ \/ p ZZ)^times$ in later sections, but we'll start with this assumption.

== Diffie-Hellman Key Exchange

When two people communicate through the Internet, they must do so through their internet service providers (ISPs). In the case of a public network, there may be malicious people pretending to be the router, thus making it so that your internet traffic goes through them. This is called a man-in-the-middle attack. // TODO(This needs to be revised)

If the information being communicated is encrypted, then man-in-the-middle attacks would not work. Common encryption algorithms require the people involved to have a *shared secret*, for example a string of characters that only the two parties know. This is hard to do when the only form of communication is through an *insecure channel*, as in the case of internet connections. The Diffie-Hellman Key Exchange proposes a way to establish a shared secret even if the only channel to communicate in is insecure through the difficulty of the discrete log problem.

The mechanism is as follows:

Given a known base $g$ in a group $G$ (with exponentiation meaning repeated application of the group operation), Alice can establish a shared secret with Bob by generating secret integers. Alice can secretly generate $a$ and send Bob $g^a$, while Bob can secretly generate $b$ and send Alice $g^b$.

Alice can then compute $(g^b)^a$ and Bob can compute $(g^a)^b$. As both of these are equivalent to multiplying $g$ to itself $a b$ times, $(g^b)^a=(g^a)^b=g^(a b)$ can be used as the shared secret.

Because only $g$, $g^a$, and $g^b$ are sent across the channel, any third party observer will not be able to compute $g^(a b)$ without solving the discrete log problem to determine $a$ or $b$. As we have assumed that the discrete log problem is difficult, this is a secure way for Alice to establish a shared secret with Bob if the only form of communication between the two is insecure.



== Elliptic curves

Let an elliptic curve be denoted by the equation $y^2 = x^3 + A x + B$ where $A$ and $B$ are constants. Note that the curve is symmetric about the $x$-axis, since if $(x,y)$ is a point on the curve, $(x,-y)$ is also on the curve.

Let $P_1 = (x_1,y_1)$ and $P_2 = (x_2,y_2)$ be distinct points on the curve, where $x_1 !=x_2$. We can find a new point on the curve by defining a line that goes across the two points, with slope

$
m = (y_2 - y_1)/(x_2 - x_1)
$

And line equation $
y = m(x-x_1) + y_1
$

We substitute this into the equation of the curve:

$
(m(x-x_1) + y_1)^2 = x^3 + A x + B
$

Expanding and rearranging gives:

$
x^3 - m^2 x^2 + (2m^2 x_1 - 2y_1m + A)x + 2y_1 m x_1 - m^2 x_1^2 - y_1 = 0
$

With Vieta's formulas, the sum of roots for the cubic is $m^2$. We already know two roots of this polynomial as $P_1$ and $P_2$ are common points on the curve and the line, so we can find the $x$ coordinate of the third point:

$
x_3 = m^2 - x_1 - x_2
$

In the group law, the $y$ coordinate of the resulting point is flipped: (TODO: explain why)

$
y_3 = -(m(x_3 - x_1) + y_1) =m(x_1-x_3) -y_1
$

Therefore, we have arrived at $P_3 = (x_3, y_3)$, a third point distinct from $P_1$ and $P_2$.

If only one point $P_1 = (x_1, y_1)$ is known, we can use implicit differentiation to find the tangent line:

$
y^2 = x^3 + A x + B\
2 y (dif y)/(dif x) = 3x^2 + A\
m = (dif y)/(dif x) = (3x^2 + A)/(2y) = (3x_1^2 + A)/(2 y_1)
$

With the same line equation $y = m(x - x_1) + y_1$, with the same expanded formula:

$
x^3 - m^2 x^2 + ... = 0
$

But this time, $x_1$ is a repeated root, as a tangent line either touches no other points at all (the case when $y = 0$) or touch one other point.

Therefore, we can find the third point with

$
x_3 = m^2 - 2 x_1
$

And $
y_3 = -(m(x_3 - x_1) + y_1) = m(x_1 - x_3) - y_1
$

Therefore, we can begin to define a group law for points on elliptic curves.

Let $C: y^2 = x^3 + A x + B$ be the elliptic curve with the set of points that satisfy the given equation. We now show that $C union {infinity}$ forms a group.

Let $P_1 = (x_1, y_1)$ and $P_2 = (x_2, y_2)$ be two points that are on the curve. Define $P_3 = P_1 + P_2$ to be as follows:

- If $P_1 = P_2 = (x_1, y_1)$, let $

P_3 = (m^2 - 2x_1, m(x_1-x_3)-y_1), "where " m = (3x_1^2 + A)/(2y_1)

$
- If $x_1 = x_2$ but $y_1 != y_2$ (N.B. the only case where this happens is $y_1 = -y_2$): let $P_3 = infinity$.
- Otherwise, let $
P_3 = (m^2 - x_1 - x_2, m(x_1-x_3)-y_1), "where " m = (y_2-y_1)/(x_2-x_1)
$

Additionally, define $P_1 + infinity = infinity + P_1 = P_1$, as well as $infinity + infinity = infinity$.

Proof that $C union {infinity}$ forms a group:

1. The operation $+$ is well-defined for any points $P_a + P_b$ where $P_a, P_b in C union {infinity}$ as above.
2. $infinity$ is the identity element, where $P_a + infinity = P_a$ for all $P_a in C union {infinity}$.
3. Every element has an inverse: let $P_a = (x, y)$, its inverse is $-P_a = (x, -y)$. TODO show that $-P_a in C$.
4. The operation is associative, where $(P_1 + P_2) + P_3 = P_1 + (P_2 + P_3)$. This is shown in chapter 2.4 in the book titled "Elliptic Curves: Number Theory and Cryptography", and the proof gets too long, so we have omitted it here.



