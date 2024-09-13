#import "@preview/cetz:0.2.2"
#import "@preview/wordometer:0.1.2": word-count, total-words
#show par: set block(spacing: 1.5em)
#set par(
  justify: true,
  leading: 0.75em
)
#set text(font: "IBM Plex Sans")



#heading(outlined: false)[To what extent can elliptic curves be used to establish a shared secret over an insecure channel?]

// TODO Title
// TODO category
// TODO see EE guide for cover page


#show: word-count.with()

Words: #total-words

#pagebreak()

#outline(indent: 2em)

#pagebreak()

= Introduction

Our society is built on cryptography. Cryptography is built on math. This essay will discuss the math behind the cryptography that is behind our society.

Well, more specifically, _one_ specific method in cryptography, which provides _one_ functionality that is in such a broad use today. 99.3% of the top 1 million websites prefer this method over others to encrypt their users' internet connections with them.@warburton_2021_2021

To take a look at why we want cryptography, let's situate ourselves in a time and place where Bob wants to send something to Alice, with an extra adversary named Eve. Eve dislikes Bob and Alice, and will try to get information from the communication in any way she can. One conventional cryptographic technique called _public key cryptography_ can help Bob in sending messages securely.

Under public key cryptography, Alice and Bob both have a pair of keys, one key that is known by the public called their public key, and one key that is kept as a secret called the private key. Under this system, Bob can use cryptographic methods based on Alice's public key to encrypt a message that only Alice can decrypt using her private key.

There are some disadvantages to this method. One is that encryption using public keys is often slower than _symmetric cryptography_, where a password only known to both sides is used to encrypt  and decrypt messages instead. A simple solution for this scenario would be Bob could create a password, use Alice's public key to send this password securely to her, and then use the password for future communications.@sako_public_2005

But that can also be insecure. If Eve keeps a record of all encrypted messages sent between Bob and Alice, and she obtains Alice's private key, she will be able to decrypt the passwords, and therefore the messages. On cryptographic terms, we say that this method does not have _forward secrecy_.

But then there came Diffie and Hellman. With the cryptographic technique called Diffie-Hellman Key Exchange in their papers, Alice and Bob can quickly establish a password, while Eve is unable to obtain the password just from inspecting their communication. This is great for Alice and Bob, as they can generate a password each time they communicate. If Eve ever finds out the password for one of their messages, she would not be able to decrypt the other messages.@krawczyk_perfect_2005@just_diffiehellman_2005

Diffie-Hellman Key Exchange is designed specifically so that people can establish a shared secret (the password between Alice and Bob) over an insecure channel (a communication method that Eve can eavesdrop). Note that additional cryptographic techniques are used to prevent _tampering_, in a situation where Eve can modify any messages sent between Alice and Bob. Tampering, and methods that are resistant to it, are out of scope for this paper.

Diffie-Hellman takes on different forms. There is Finite Field Diffie-Hellman and Elliptic Curve Diffie-Hellman. We'll look at both techniques and compare the two methods in terms of how efficient they are (how much data does Alice and Bob need to send to each other?) and how fast they are (how quickly can Alice and Bob calculate the shared password in an exchange?)

= Group Theory

== $ZZ_p^times$: The Multiplicative Group Over a Prime

Fermat's Little Theorem suggests the following to be true for any integer $a$ and prime $p$:

$
a^(p-1) equiv 1 " " (mod p)
$

Extracting a factor of $a$, we get

$
a dot a^(p-2) equiv 1 " " (mod p)
$

Thus, under multiplication modulo $p$, any integer $a$ multiplied by $a^(p-2)$ results in 1. As 1 is the multiplicative identity ($1 dot x = x$), $a^(p-2)$ is said to be $a$'s _multiplicative inverse_. Consider the set of numbers from $1$ to $p - 1$. Every number $a$ has a multiplicative inverse $a^(p-2)$ modulo $p$; The set contains an identity element ($1$); Multiplication is associative ($a dot (b dot c) = (a dot b) dot c$); And each multiplication will always result in a number between $1$ to $p - 1$ since it is performed modulo $p$. These properties, existence of an identity element and inverses, associativity, and the closure of operations, are exactly the properties that define a group.

A group is, at its core, a set. We'll use some of the same language with sets, for example the $in$ symbol and the word _element_. We will refer to the specific group we discussed above as $ZZ_p^times$. The subscript is the _modulus_ of operations, while the superscript specifies the operation. In a similar vein, $ZZ_p^+$ refers to the same set of numbers (though also including the number $0$, unlike multiplication), but specifies addition as its group operation.

The _order_ of a group refers to the number of elements in that group. For $ZZ_p^times$, the order is $p - 1$ since the elements are $1, 2, ..., p - 1$. Using notation, we write $|ZZ_p^times| = p - 1$. As per above, the additive group includes zero, therefore $|ZZ_p^+| = p$.

The _order_ of a specific element $x$, refers to the smallest integer $k$ such that $x^k = 1$, where $1$ is the identity element. For example, the order of $17$ in $ZZ_1009^times$ is $1008$, because $17^1008=1$ and $1008$ is the smallest smallest exponent to give $1$, whereas the order of $2$ in the same group is $504$, since $2^504 = 1$ and $504$ is the smallest exponent. Therefore, we have $|17| = 1008$ and $|2| = 504$.

== The Discrete Log Problem

Under a specific group $ZZ_1009^times$, we ask for an integer $n$ for which $17^n = 24$. In this case,

$
17^(456) equiv 24 " " (mod 1009)
$

Therefore $n = 456$ is the solution to this question. More generally, the discrete log problem (DLP) asks for a smallest exponent $n$ for a given group $g$ and its elements $a$ and $b$ such that

$
a^n = b
$

Given this problem, one might take the brute-force approach, repeatedly performing the group multiplication, calculating $a^2$, $a^3$, $a^4$ and and comparing each with $b$. In the example problem, it would take $455$ multiplications before finally arriving at the answer. Assume the algorithm is tasked to solve questions of this kind repeatedly with the exponent $n$ taken at random. This algorithm would take on average $1/2|a|$ operations. As the order $|a|$ gets big (towards numbers as big as $2^200$), this approach quickly becomes infeasible.

The assumption that the discrete log cannot be solved trivially in specific groups is the core of cryptographic protocols and algorithms. There are known techniques better than a brute-force search which can solve the discrete log problem either for specific groups or for all groups in general. We shall discuss those methods in a later section, though cryptography is done on well-chosen groups such that even those more advanced attacks become infeasible.



/* Addition within the set of integers satisfy certain algebraic properties:

1. There exists an identity. For addition, $0$ is the identity becuase $0 + a = a$.
2. The operation is associative, where $(a + b) + c = a + (b + c)$.
3. Every element has an inverse that is also within the set. For any $a in ZZ$, $-a$ is its inverse because $a + (-a) = 0$ where $0$ is the identity element.
4. Closure. For any $a, b in ZZ$, we have $a + b in ZZ$ as well, therefore the operation will never output a value that leaves the $ZZ$ set.

These four conditions satisfy the requirements for a _group_. We can say that the set of $ZZ$ forms a group under addition. Note that $ZZ$ does _not_ form a group under multiplication, because although it satisfies three of the properties: $1$ is the identity, the operation is associative, and for all $a,b in ZZ, a b in ZZ$ (closure), the inverse property is not satisfied.

For $2$ to have an inverse, there would need to be $a in ZZ$ such that $2  times a = 1$, the identity element. Such an $a$ doesn't exist when $a$ needs to be an integer.

However, we can restrict our set to make it form a group. Consider the numbers ${1, 2, 3, .., n - 1}$ with multiplication modulo $n$, where $n$ is a prime number. We will write this set as $ZZ_n$.

For any $a in ZZ_n$, we have $1 times a = a$, therefore $1$ can be considered as the identity element. The operation is associative in the same way multiplication is associative, with the assumption that multiplying two numbers modulo $n$ is equivalent to multiplying in $ZZ$ then finding the result modulo $n$. Then, as $(a b)c = a(b c)$, we can say $(a b) c = a (b c) " "(mod n)$.

Finding an inverse for an element in $ZZ_n$ requires the use of Fermat's Little Theorem, which states

$
a^(n-1) equiv 1 " "(mod n)
$

when $n$ is prime. Then, we can write $a times a^(n-2) equiv 1 " "(mod n)$. For any $a in ZZ_n$, $a^(n-2)$ is its inverse as the product of $a$ and $a^(n-2)$ gives the identity. It's trivial to show that $ZZ_n$ is closed under multiplication, therefore we can state that the set of non-zero integers modulo $n$ forms a group under multiplication. 

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
For any integer $a$ and prime $p$. We have found $a^(p-2)$ as $a$'s multiplicative inverse, therefore integers modulo $p$ with multiplication forms a group, as the operation is associative, has an identity element, and every element has an inverse. This group is represented with the symbol $ZZ_p^times$.

Given a base $17$ and a value $24$, we can ask the following question:

$
17^n equiv 24 " "(mod 1009)
$

This is called the Discrete Log Problem in $ZZ_p^times$, and in this case $p = 1009$. It is an open cryptographic problem to be able to solve this problem in large $p$ quickly. 

A method named pollard's $rho$ algorithm exists which we can use to find the answer. First, we generate random integers as exponents and write $M$:

$
M_1 = (17)^5 (24)^11\
M_2 = (17)^20 (24)^7\
M_3 = (17)^13 (24)^6\
M_4 = (17)^11 (24)^16\
M_5 = (17)^3 (24)^12
$

// todo probably rename P to x

Then, define $
f(x) = x M_i "if " x equiv i " " (mod 5)
$

This essentially gives a "random walk" of the group. Choose $P_0 = (17^3)(24^14)$, then define $
P_(n+1) = f(P_n)
$

We note that $P_61 = P_99 = 340$. If we kept track of the exponents on $17$ and $24$ in the calculations, we get

$
P_61 = (17^691)(24^704) = (17^1075)(24^1132) = P_99
$

Then

$
17^(-384) = 24^(428)
$

Rewrite $24 = 17^k$

$
17^(-384) = 17^(428k)\
17^(428k + 384) = 1
$

Note that $17$ has order $1008$ in the multiplicative group modulo 1009, therefore we write

$
428 k + 384 = 0 " "(mod 1008)
$

// TODO
(pollards rho, from Washington)

Given $a$ and $b$ are non-zero integers from this group, the discrete log problem asks us to find $k$ such that

$
a^k equiv b " " (mod p)
$


The assumption is that this problem is difficult to compute if the group and the exponent are well-chosen. This is used as the _trapdoor function_ in cryptography, as it is assumed to be easy to compute in one direction and hard to compute in the other. We'll evaluate the extent to which this claim is true for $ZZ_p^times$ in later sections, but we'll start with this assumption. */

= Finite Field Cryptography and Attacks

The term _finite field_ refers to the fact that the set of numbers from 1 to $p - 1$, alongside with zero, form another group under addition. Moreover, multiplication is distributive over addition: $a(b + c) = a b + a c$ mod $p$. A field is a set of elements that forms a group under addition and its non-zero elements forms a group under multiplication, where multiplication distributes over addition. The field of integers modulo $p$ is written as $FF_p$. Note that $|FF_p| = p$ due to the inclusion of zero. We use $FF_p^times$ to explicitly refer to the multiplicative subgroup where $|FF_p^times| = p-1$.

== Diffie-Hellman Key Exchange

Building off the previous example, suppose we're given the numbers $407$ and $24$, which are both exponents of a known base $17$ in $FF_1009^times$. Let's let $
17^a equiv 407  " " (mod 1009)\
17^b equiv 24 " " (mod 1009)
$

Is it possible for us to find $17^(a b)$? If we know the value of $a = 123$, we can raise $24$ to $123$.

$
17^b = 24 #h(55pt) a = 123\
17^(a b) = (17^b)^a = 24^123 = 578
$

More generally, if we know $17^a$ and the exponent $b$, or if we know $17^b$ and the exponent $a$, it would be possible for us to know $17^(a b)$. But just being given $17^a$ and $17^b$ in this case would make it less trivial.

This problem of finding $x^(a b)$ when just given $x$, $x^a$, and $x^b$ is named the Diffie-Hellman problem, and it is not hard to see that the difficulty of this problem relates to the difficulty of the Discrete Log Problem, since solving the Discrete Log would give us the answer to the Diffie-Hellman problem. Assuming the Diffie-Hellman problem is difficult, we can use this to setup a cryptographic exchange. 

/*
Given a known base $x$ within a group $G$, one cannot trivially obtain $x^(a b)$ from just $x^a$ and $x^b$ if the integers $a$ and $b$ are not known. (Exponentiation here means repeated application of the group operation. In groups where the operation is normally known as addition (such as elliptic curves), we will write $a x$ and $b x$ instead.)

This is named the Diffie-Hellman problem. If the discrete log problem can be solved trivially, one can simply obtain $b$ from $x^b$ and $x$, then exponentiate $(x^a)^b = x^(a b)$. As such, the difficulty of the Diffie-Hellman problem in a group is partially related to the difficulty of solving DLP in the same group.
*/

Consider the following case where anything sent between Alice and Bob can be seen by Eve. Alice knows that $17^123 equiv 407$, but only sends Bob $407$. Bob knows that $17^456 equiv 24$, but only sends Alice $24$. After exchanging their information, Alice can compute $24^123 equiv 578$, and Bob can also compute $407^456 equiv 578$. Eve, only intercepting the numbers $17, 407, 24$ in their communication, is unable to calculate the secret number $578$ without solving the Diffie-Hellman problem.

#figure(image("Diffie-Hellman.svg", width: 80%), caption: [Diagram by author, a description of the Diffie-Hellman Key Exchange process.])

\

To generalize, the Diffie-Hellman Key Exchange utilizes the difficulty of the Diffie-Hellman problem. Under an agreed upon group $G$ and base $x in G$, two parties Alice and Bob can establish a shared secret. Alice can generate an exponent $a$ and send Bob $x^a$, while Bob can generate a secret exponent $b$ and send Alice $x^b$. Together, they can both compute $x^(a b)$ as their shared secret securely, even if Eve is able to intercept this communication.

The specific example we did is done in $FF_1009^times$. In reality, the size of the field will be much larger to prevent anyone from trivially breaking the exchange and finding the secret @friedl_diffie-hellman_2006@velvindron_increase_2017. The more general technique of performing Diffie-Hellman on the multiplicative subgroup of a finite field is called Finite Field Diffie-Hellman. We will describe another technique named Elliptic Curve Diffie-Hellman later, but first, we can consider ways to break the current example.

/*With the Diffie-Hellman problem, Alice can establish a shared secret with Bob by having both generate their own secret exponent - either $a$ or $b$. Alice can secretly generate $a$ and send Bob $x^a$, while Bob can secretly generate $b$ and send Alice $x^b$.

Alice can then compute $(x^b)^a$ and Bob can compute $(x^a)^b$. As both of these are are equal to $x^(a b)$, this can be used as the shared secret.

Because only $x$, $x^a$, and $x^b$ are sent across the channel, any third party observer will not be able to compute $x^(a b)$ without solving the Diffie-Hellman problem. As we have assumed that the problem is difficult, this is a secure way for Alice to establish a shared secret with Bob over an insecure channel.
*/
/* 
#align(center, cetz.canvas({
  import cetz.draw: *
  content((0, 0), (2, 1), box(align(center, par[Alice]),
stroke: 1pt, width: 100%, height: 100%, inset: 1em))
  content((7, 0), (9, 1), box(align(center, par[Bob]),
stroke: 1pt, width: 100%, height: 100%, inset: 1em))
  // TODO finish this
}))
*/

== Index Calculus

Diffie-Hellman Key Exchange on Finite Fields normally uses groups $FF_p$ where $2^2048 <= p <= 2^8192$ @friedl_diffie-hellman_2006@velvindron_increase_2017. The large size of the prime ensures that solving DLP is inefficient. Below we will describe Index Calculus, which efficiently solves DLP for smaller finite fields.

It is best to illustrate with an example. We'll reuse the one presented earlier:

$
17^n equiv 24" (mod 1009)"
$

To find $n$, we first define a logarithm function $L$. $L(x)$ is defined such that

$
17^L(x) equiv x" (mod 1009)"
$

Therefore, our goal is to find $L(24)$.

Note that when we have

$
17^(L(x) + L(y)) equiv 17^(L(x)) times 17^(L(y)) equiv x y equiv 17^(L(x y))" (mod 1009)"
$

So then $
17^(L(x) + L(y) - L(x y)) equiv 1" (mod 1009)"
$

Because $|17| = 1008$, we have (notice the change in modulus from $1009$ to $1008$)

$
L(x) + L(y) - L(x y) &equiv 0&" (mod 1008)"\
L(x) + L(y) &equiv L(x y)&" (mod 1008)"
$

As such, we have a relation analogous to the laws of logarithm on real numbers. Since every number can be factorized into primes, the idea is the obtain $L(p)$ for small primes $p$, then figuring out $L(24)$ afterwards. We first try to factorize exponents of the base, $17$, looking for ones that can be factorized into relatively small primes:

$
17^15 &equiv 2^2 dot 5 dot 13&" (mod 1009)"\
17^16 &equiv 2^7 dot 3&" (mod 1009)"\
17^24 &equiv 2 dot 11^2&" (mod 1009)"\
17^25 &equiv 2 dot 3 dot 13&" (mod 1009)"\
17^33 &equiv 2^2 dot 3^2 dot 11&" (mod 1009)"\
17^36 &equiv 2^2 dot 7^2&" (mod 1009)"\
$

Applying $L$ to both sides of the equations, we obtain

$
15 &equiv 2 L(2) + L(5) + L(13)&" (mod 1008)"\
16 &equiv 2 L(7) + L(3)&" (mod 1008)"\
24 &equiv L(2) + 2L(11)&" (mod 1008)"\
25 &equiv L(2) + L(3) + L(13)&" (mod 1008)"\
33 &equiv 2 L(2) + 2 L(3) + L(11)&" (mod 1008)"\
36 &equiv 2 L(2) + 2 L(7) &" (mod 1008)"\
$

There are six unknowns $L(2), L(3), L(5), L(7), L(11), L(13)$ and six equations, using linear algebra methods, we can arrive at the solution

$
L(2) = 646, L(3) = 534, L(5) = 886,\
L(7) = 380, L(11) = 697, L(13) = 861
$

Next up, the idea is to find $17^x dot 24$ and find one that can factorize over primes not greater than 13. Indeed, we have $17^2 dot 24 equiv 2 dot 3^2 dot 7^2" (mod 1009)"$, so then we have

$
2 + L(24) equiv L(2) + 2L(2) + 2L(7)" (mod 1008)"\
L(24) = 456 = n
$

Therefore, we indeed arrive at the answer $n = 456$. As seen above, this method relies on the property that prime factorizations always exist, which does not apply to most ellpitic curves. @washington_elliptic_2008[pp.~154-157]

For the example above, we examined exponents of $17$ up to $17^36$, and also computed $17 dot 24$ and $17^24$. This takes significantly less time than enumerating $17^n$ for all $n$ until we reach 456. Therefore, Index Calculus is much more efficient than brute-forcing.

We've just descibed the basic algorithm for Index Calculus, there is a more sophisticated method called General Number Field Sieve which builds upon index calculus. GNFS is in general more efficient than simple index calculus for large primes @nguyen_index_2005. The number of operations expected for the GNFS algorithm can be written as @lenstra_l-notation_2005:

$
exp((64\/9)^(1\/3)(ln p)^(1\/3)(ln ln p)^(2\/3))
$

where $p$ is the prime that defines the finite field in $FF_p$. For a field with $p = 2^2048$, the expected running time for GFNS to solve the Discrete Log would take about $1.5 dot 10^35 approx 2^117$ operations. In later sections, we will take a look at Diffie-Hellman done on elliptic curves and how the number of operations needed to solve the discrete log problem on elliptic curves compares with Diffie-Hellman on finite fields.

= Elliptic Curve Cryptography

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
y_3 = -(m(x_3 - x_1) + y_1) = m(x_1-x_3) - y_1
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

Perhaps the most surprising result of defining this operation is that the operation is associative, that is, $(P_1 + P_2) + P_3 = P_1 + (P_2 + P_3)$ for any three points $P_1, P_2, P_3$ that belong to the set $C union { infinity }$. Proving this algebraicly becomes very tedious, but there is a geometric argument using cubics and Bézout's theorem for the case where the points are distinct and none of them have the same $x$ value.

== Proof of Associativity

A cubic space curve is given with the following formula @silverman_rational_2015:

$
a x^3 + b x^2 y + c x y^2 + d y^3 + e x^2 + f x y + g y^2 + h x + i y + j = 0 
$

A consequence of Bézout's theorem states that two cubic space curves intersect at 9 points, counting multiplicities such as self-intersections. In our case, we ignore multiplicities so the curves will intersect at 9 distinct points.

We now summarize the proof of the follow theorem in @silverman_rational_2015:
#quote(block: true)[
  Let $C$, $C_1$, $C_2$ be cubic space curves. Suppose $C$ goes through eight of the nine intersection points between $C_1$ and $C_2$. Then $C$ also goes through the nineth intersection point.
]

This theorem is used in the graphical proof of associativity in elliptic curves.

Firstly, note that a total of 10 coefficients were used in the formula for a cubic space curve: $a, b, c, d, e, f, g, h, i, j$. If the equation is scaled by a linear factor, it results in the same curve, so we can say that this curve is nine-dimensional (constrained by nine linear factors).

Constraining a curve to go through a single point reduces its dimension by one, therefore the set of all curves that go through eight specific points is one-dimensional.

Suppose $C_1$ is specified by the equation $F_1(x, y) = 0$ and $C_2$ by $F_2(x, y) = 0$. Then any intersection point $(x_1,y_1)$ will satisfy $F_1(x_1, y_1) = F_2(x_1, y_1) = 0$. Therefore, a linear combination of the two functions will result in a cubic space curve that goes through the eight intersection points: $F_3 = lambda_1 F_1 + lambda_2 F_2$. Since this linear combination also represents a one-dimentional family of cubic space curves, it follows that $C$ must also be specified by $F_3(x, y) = 0$ for specific factors $lambda_1$ and $lambda_2$.

Since we know that the nineth intersection point also satisfies $F_3(x, y) = 0$, we know that $C$ goes through the nineth intersection point.

Now, we use this theorem to prove that the elliptic curve point addition operation is associative.

Formally, the group of elliptic curves can be defined in projective space. There is a point at infinity which also satsify certain geometric properties including Bézout's theorem. For ease of presentation, the point at infinity will be denoted as $O$ and shown in the diagram.

#figure(image("Screenshot_20240626_152533.png"), caption: [By author, graphical proof of associativity])

On the elliptic curve, we first start with three points, $P$, $Q$, and $R$. To create $Q * R$ and $P * Q$, we draw a line between the two points and take the third intersection point on the curve as the result. To find $Q + R$ and $P + Q$, we take the starred point ($Q * R$ for example), draw a line from it to $O$, then take the third intersection point. Note that this is equivalent to "flipping" the intersection point used in the definition of elliptic curve addition.

$(P + Q) * R$ is formed through finding the third intersection in the line between $P + Q$ and $R$, and $P * (Q + R)$ is formed through finding the third intersection in the line between $P$ and $Q + R$. Proving that these two points are equal proves associativity.

Next, we draw six lines. The three blue lines go through $(P+Q)*R$, $P$, $Q$, $R$, $Q*R$, $Q+R$, $P*R$, $P+Q$, and $O$. The three black lines $P * (Q + R)$, $P$, $Q$, $R$, $Q*R$, $Q+R$, $P*R$, $P+Q$, and $O$.

Three lines form a cubic space curve:

$
(y - (m_1 x + b_1))(y - (m_2 x + b_2))(y - (m_3 x + b_3)) = 0
$

Let $C_1$ be the elliptic curve (itself a cubic space curve), and let $C_2$ be the cubic space curve formed through the three black lines. As $C$, the cubic space curve formed through the three blue lines, go through eight of the nine points that are intersections between $C_1$ and $C_2$: $P$, $Q$, $R$, $Q*R$, $Q+R$, $P*R$, $P+Q$, and $O$, the last point of intersection must be same. The last point on $C_2$ is denoted $P * (Q + R)$, while the last point on $C$ is denoted $(P + Q) * R$, therefore, we have proven $P * (Q + R) = (P + Q) * R$, which implies $P + (Q + R) = (P + Q) + R$, proving the associativity.

== Group of elliptic curve points

Therefore, $C union {infinity}$ forms a group since:

1. The operation $+$ is well-defined for any points $P_a + P_b$ where $P_a, P_b in C union {infinity}$ as above.
2. $infinity$ is the identity element, where $P_a + infinity = P_a$ for all $P_a in C union {infinity}$.
3. Every element has an inverse: let $P_a = (x, y)$, its inverse is $-P_a = (x, -y)$. We know that $-P_a in C$ since the curve is given as $y^2 = x^3 + A x + B$ and swapping $y$ with $-y$ will still hold.
4. The operation is associative.

Since elliptic curve points form a group, cryptographic techniques such as diffie-hellman key exchange which relies on group operations can also be applied to elliptic curves.

== Elliptic curve diffie-hellman

One important difference between elliptic curve operations and modular multiplicative group operations is in notation. In elliptic curve, the operation is commonly represented as addition of two points. Therefore $A + B$ is the normal operation on two points $A$ and $B$ while $k A$ is the operation repeated (e.g. $2A = A + A$). In the multiplicative group modulo $p$, the correspondence goes to $A B$ and $A^k$. Thus, in previous sections about the multiplicative groups, an operation such as $A^k$ will now be written as $k A$ in the context of elliptic curves.

With that note, diffie-hellman in elliptic curves follows the exact same procedure: two parties agree on a curve group to use, then decide on a base point $G$. Alice generates a secret integer $a$ and sends Bob $a G$. Bob generates a secret integer $b$ and sends Alice $b G$. They can now both calculate $a b G$, which cannot be known by third parties unless they can solve the discrete log problem in elliptic curves.

// TODO: Example

== Finding the Discrete Log with Pollard's $rho$ algorithm

Pollard's $rho$ algorithm is a general algorithm for solving the discrete log problem for any abelian group. It is less efficient than the general number field sieve on discrete log in finite fields, taking $O(sqrt(N))$ time on average with $N$ being the order of the group. // TODO revisit

We first take an example adapted from page 164 of Silverman and Tate's book: $y^2 = x^3 + 6692x + 9667$, in $F_10037$, with $P = (3354, 7358)$, $Q = (5403, 5437)$. Find $k$ such that $k P = Q$.#footnote[Originally a Montgomery equation, used substitution to turn it into the short Weierstrass form for consistency.]

Generate 10 random points on the curve based on multiples of $P$ and $Q$:

// TODO make these occupy less space.
$
M_0 = 42P + 37Q #h(25pt) M_1 = 21P + 12Q #h(25pt) M_2 = 25P + 20Q\
M_3 = 39P + 15Q #h(25pt) M_4 = 23P + 29Q #h(25pt) M_5 = 45P + 25Q\
M_6 = 14P + 37Q #h(25pt) M_7 = 30P + 12Q #h(25pt) M_8 = 45P + 49Q #h(25pt) M_9 = 40P + 45Q\
$

Then pick, in the same way, a random initial point:

$
A_0 = 15P + 36Q = (7895, 3157)
$

Then, choose an $M_i$ point to add to based on the ones digit of the $x$ coordinate of the point. As $A_0$ has $x = 7895$, $A_1 = A_0 + M_5 = (7895, 3157) + (5361, 3335) = (6201, 273)$.

Formally, define $
A_(n+1) = A_n + M_i" where " i equiv x_n" (mod 10)"
$

for $A_n = (x_n,y_n)$.  The choice of random $M_i$ points creates a kind of "random walk" of the points in the elliptic curve. As we keep calculating, we get:

$
A_0 &= (7895, 3157), A_1 &=& (6201, 273), ...,\
A_95 &= (170, 7172), A_96 &=& (7004, 514), ...,\
A_100 &= (170, 7172), A_101 &=& (7004, 514) 
$

We reach a cycle with $A_95 = A_100$. Since we know the multiples of $P$ and $Q$ for all of the $M_i$ points and thus all $A_n$ points, keeping track of them gives us $A_95 = 3126P + 2682Q$, we also have $A_100 = 3298P + 2817Q$. With $3126P + 2682Q = 3298P + 2817Q$, we have:

$
infinity = 172P + 135Q = (172 + 135n)P\
172 + 135n equiv 0" (mod 10151)"\
n equiv 1277" (mod 10151)"
$

With verification, we indeed have $1277P = Q$.

= Evaluation

Pollard's $rho$ algorithm on elliptic curve groups works on average with $sqrt(pi/4 N)$ elliptic curve additions with $N$ being the order for the base point $P$ @bernstein_correct_2011. On the other hand, the general number field sieve takes about $exp((64\/9)^(1\/3)(ln p)^(1\/3)(ln ln p)^(2\/3))$ in a prime field with order $p$. Assigning real numbers to these expressions, we can evaluate the current industry standards.

== Diffie-Hellman in TLS 1.3

The Transport Layer Security (TLS) protocol is the protocol used in virtually all internet connections that are protected through cryptography @heinrich_transport_2011. One important part of this protocol is Diffie-Hellman Key Exchange. As of writing, the latest version of TLS is 1.3. We shall now examine the Diffie-Hellman methods it supports.

=== Finite Field Diffie-Hellman

The smallest finite field used by TLS for Diffie-Hellman is named ffdhe2048 @rescorla_transport_2018, with the prime modulus defined as $
p = 2^2048 - 2^1984 + (floor(2^1918 dot e) + 560316) dot 2^64 - 1
$

With the group size being $(p - 1) \/ 2$. If we computed the number of operations needed for the general number field sieve to run, we get approximately $2^117$ operations or that the field provides 117 bits of security. The original definition /* TODO from where? */ indeed has taken a conservative estimate that this provides 103 bits of security @gillmor_negotiated_2016.

As this field uses a prime 2048 bits of size, each group element requires 2048 bits of storage or 2KiB of storage.

=== Elliptic Curve Diffie-Hellman

The smallest elliptic curve supported by TLS appears to be curve25519, using the prime $2^255 - 19$ as the field the elliptic curve is over, and the curve $y^2 = x^3 + 486662 x^2 + x$. The order of the group is $2^252 + 27742317777372353535851937790883648493$. As the fastest method to break the discrete logarithm takes $sqrt(pi/4 N)$ operations, this specific curve requires approximately $2^126$ operations to break, or providing 126 bits of security.

As elliptic curve points have coordinates under the prime field $2^255 - 19$, each coordinate requires 255 bits of storage, making the point requiring 510 bits of storage. Therefore, each group element requires approximately 0.5KiB of storage.

== Performance of group operations

Assume that multiplying two $256$-bit integers has cost $bold(C)$. Multiplication of two $2048$-bit integers thus will cost $64bold(C)$ as each $2048$-bit integer has $8$ $256$-bit digits and each digit from the first operand needs to multiply with the next operand.

The story in elliptic curves is much more complicated. Curve25519 follows the form $B y^2 = x^3 + A x^2 + x$ called a Montgomery curve. All curves of this form can be transformed into the short Weierstrass form but not the other way around. Detailed in @costello_montgomery_2018, the diffie-hellman key exchange protocol could be designed so that only the $x$-coordinate of each point in the process is needed, which simplifies the process by removing the need to compute $y$ coordinates. Under the arithmetic of only the $x$ coordinates of curve points, adding two curve points costs $3M + 2S + 3a + 3s$, where $M, S, a, s$ are costs for multiplying two numbers, squaring a number, adding two numbers, subtracting two numbers in the field the curve is defined on respectively. Assuming that the cost for addition and subtraction is negligible compared to multiplication, and assuming that squaring has approximately the same cost as multiplying two numbers,#footnote[In reality, squaring has slightly less costs than multiplying as the former can be optimized a bit more for efficiency.] the cost for adding two curve points is approximately $5M$. Note that the field is defined over $2^255 - 19$, so the cost of a multiplication $M$ (for two $255$-bit integers) can be considered as less than the cost of multiplying two $256$-bit integers. So we have $M < bold(C)$.

Note how adding two curve points only costs $5M$, while multiplying in finite fields costs $64bold(C)$. (approximately 13x difference) As performing the group operation is the primary backbone behind Diffie-Hellman key exchange, this performance difference can have huge implications.

/* Doubling a curve point costs $2M + 2S + 1c + 3a + 1s$ where $c$ is the cost of multiplying by $(A + 2) / 4 = 121666$ for curve25519. For the same reason we assume that this costs approximately $4M$. */

== Comparison

The specific methods we have chosen to evaluate provide a general insight into the efficiencies of different methods of diffie-hellman key exchange. In general, elliptic curves take much less space to store, providing similar bits of security while using approximately four times less storage for each group element, and is able to perform group operations at much faster speeds, providing an approximate 13x speedup compared to older methods.

= Conclusion

Elliptic curves offer a much better alternative to existing cryptographic methods and is representative of the progress mathematicians have made towards helping build a large system (i.e. the Internet) that scales. To answer the question of "To what extent can elliptic curves be used to establish a shared secret over an insecure channel", the answer is "Yes, and its fast and efficient."

#bibliography("shortlist.bib")