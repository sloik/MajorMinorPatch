---------------------------- MODULE MajorMinorPatch ----------------------------
(* Finite model of Sources/MajorMinorPatch: Semantic.Major/Minor/Patch          *)
(* (saturating incremented/decremented), Semantic.Version.<, Semantic.==/<      *)
(* over the four cases v / vi / vb / vib, identifier ordering, and the          *)
(* description <-> init?(_:) text round trip.                                   *)
(*                                                                              *)
(* Abstractions: UInt components are 0..MaxC (MaxC stands for UInt.max); in the *)
(* text model every number is ONE token ("0", "1", "01"); identifiers and build *)
(* identifiers are atomic tokens; the NSString .numeric compare is modelled by  *)
(* NumericRank (legacy mutant); semver.org by RefIdLess/AsciiRank.                        *)
(* The model follows the CODE, which since the 2026-11-13 fix follows semver.org *)
(* 2.0.0. The seven violations the model found earlier are now `legacy_*`      *)
(* mutants: each re-introduces one old bug and must be caught (see README).    *)
EXTENDS Naturals, Sequences, FiniteSets

CONSTANTS VMax,     \* AllVers = (0..VMax)^3, for Version-level laws
          MaxC,     \* stands for UInt.max in the component model
          Vers,     \* versions as decimal digit codes a*100+b*10+c (cfgs cannot hold tuples)
          IdSet,    \* subset of AllIds used as pre-release identifiers
          MaxIds,   \* max pre-release identifiers per version
          Builds,   \* build metadata tokens (one token per build)
          Mutant    \* "none" or a seeded bug

VARIABLE u
Init == u = 0
Next == UNCHANGED u
Spec == Init /\ [][Next]_u

(* ---------------- helpers ---------------- *)
RECURSIVE JoinDots(_), IdsLess(_, _)
Seqs(S, n)   == UNION {[1..k -> S] : k \in 0..n}
NESeqs(S, n) == Seqs(S, n) \ {<<>>}
JoinDots(l)  == IF l = <<>> THEN <<>>
                ELSE IF Len(l) = 1 THEN l
                ELSE <<l[1], ".">> \o JoinDots(Tail(l))

(* ---------------- components (Major/Minor/Patch.incremented/decremented) ---------------- *)
Comps == 0..MaxC
Inc(x) == IF x = MaxC THEN (IF Mutant = "inc_wraps" THEN 0 ELSE x) ELSE x + 1
Dec(x) == IF x = 0 THEN x ELSE x - 1

(* ---------------- Version.< (Semantic.Version.swift) ---------------- *)
AllVers == {<<a, b, c>> : a, b, c \in 0..VMax}
VLex(a, b)  == a[1] < b[1]
               \/ (a[1] = b[1] /\ (a[2] < b[2] \/ (a[2] = b[2] /\ a[3] < b[3])))   \* semver 11.2
\* the code: major, then minor, then patch
VLess(a, b) == IF Mutant = "legacy_version_any_component"
                 THEN a[1] < b[1] \/ a[2] < b[2] \/ a[3] < b[3]   \* pre-fix: any component less
                 ELSE VLex(a, b)
CompLE(a, b) == \A k \in 1..3 : a[k] <= b[k]
Comparable(a, b) == CompLE(a, b) \/ CompLE(b, a)

(* ---------------- identifiers ---------------- *)
AllIds == {"2", "10", "a2", "a10", "alpha", "beta"}
IsNum(i) == i \in {"2", "10"}
NumVal  == [i \in {"2", "10"} |-> IF i = "2" THEN 2 ELSE 10]
\* semver 11.1.2: alphanumerics compare lexically in ASCII order (a10 < a2).
AsciiRank == [i \in {"a2", "a10", "alpha", "beta"} |->
                IF i = "a10" THEN 1 ELSE IF i = "a2" THEN 2 ELSE IF i = "alpha" THEN 3 ELSE 4]
\* pre-fix code: Foundation compare(_, options: .numeric), digit runs as numbers (a2 < a10).
NumericRank == [i \in AllIds |->
  IF i = "2" THEN 1 ELSE IF i = "10" THEN 2 ELSE IF i = "a2" THEN 3
  ELSE IF i = "a10" THEN 4 ELSE IF i = "alpha" THEN 5 ELSE 6]
LexRank == [i \in AllIds |->     \* plain string order (seeded bug)
  IF i = "10" THEN 1 ELSE IF i = "2" THEN 2 ELSE IF i = "a10" THEN 3
  ELSE IF i = "a2" THEN 4 ELSE IF i = "alpha" THEN 5 ELSE 6]
RefIdLess(i, j) ==
  IF IsNum(i) /\ IsNum(j) THEN NumVal[i] < NumVal[j]
  ELSE IF IsNum(i) THEN TRUE
  ELSE IF IsNum(j) THEN FALSE
  ELSE AsciiRank[i] < AsciiRank[j]
\* the code (Semantic.Identifier.<): the same rule, written as numeric/alphanumeric cases
IdLess(i, j) == IF Mutant = "ids_lexical" THEN LexRank[i] < LexRank[j]
                ELSE IF Mutant = "legacy_numeric_id_compare" THEN NumericRank[i] < NumericRank[j]
                ELSE CASE IsNum(i) /\ IsNum(j) -> NumVal[i] < NumVal[j]
                       [] IsNum(i) /\ ~IsNum(j) -> TRUE
                       [] ~IsNum(i) /\ IsNum(j) -> FALSE
                       [] OTHER -> AsciiRank[i] < AsciiRank[j]

\* ArraySemantic.Identifier.swift  [Identifier] <
IdsLess(l, r) ==
  IF l = <<>> THEN (IF Mutant = "shorter_not_lower" THEN FALSE ELSE r # <<>>)
  ELSE IF r = <<>> THEN (Mutant = "shorter_not_lower")
  ELSE IF Head(l) = Head(r) THEN IdsLess(Tail(l), Tail(r))
  ELSE IdLess(Head(l), Head(r))
\* semver 11.1.4 written independently (exists a common prefix of length k)
RefIdsLess(l, r) ==
  \E k \in 0..Len(l) :
    /\ k <= Len(r)
    /\ \A j \in 1..k : l[j] = r[j]
    /\ \/ (k = Len(l) /\ Len(r) > k)
       \/ (k < Len(l) /\ k < Len(r) /\ RefIdLess(l[k+1], r[k+1]))

(* ---------------- Semantic (Semantic.swift, Semantic.Comparable.swift) ---------------- *)
Mk(k, x, i, b) == [kind |-> k, ver |-> x, ids |-> i, build |-> b]
SemSet(Vs, IL, BL) ==
     {Mk("v",   x, <<>>, <<>>) : x \in Vs}
  \cup {Mk("vi",  x, i, <<>>)    : x \in Vs, i \in IL}
  \cup {Mk("vb",  x, <<>>, b)    : x \in Vs, b \in BL}
  \cup {Mk("vib", x, i, b)       : x \in Vs, i \in IL, b \in BL}
\* Ordering domain: identifier arrays non-empty (an empty one traps in ==, see Findings).
ToTriple(n) == <<n \div 100, (n \div 10) % 10, n % 10>>
OrdSems == SemSet({ToTriple(n) : n \in Vers}, NESeqs(IdSet, MaxIds), NESeqs(Builds, 1))
OfKind(k) == {s \in OrdSems : s.kind = k}
VOnly   == OfKind("v")
VIOnly  == OfKind("vi")
VIBOnly == OfKind("vib")
Strip(a) == Mk("vi", a.ver, a.ids, <<>>)

\* Semantic.Comparable.swift: pre-release identifiers, or <<>> for a release.
PreRel(a) == IF a.kind \in {"vi", "vib"} THEN a.ids ELSE <<>>

\* pre-fix == table (asymmetric for v/vb), kept as the legacy_eq_asymmetric mutant
OldEq(a, b) ==
  LET sv == a.ver = b.ver
      si == a.ver = b.ver /\ a.ids = b.ids
  IN  IF a.kind = "v"   /\ b.kind = "v"   THEN sv
      ELSE IF a.kind = "vi"  /\ b.kind = "vi"  THEN si
      ELSE IF a.kind = "vb"  /\ b.kind = "vb"  THEN sv
      ELSE IF a.kind = "vib" /\ b.kind = "vib" THEN si
      ELSE IF a.kind = "vb"  /\ b.kind = "v"   THEN sv
      ELSE IF a.kind = "vib" /\ b.kind = "vi"  THEN si
      ELSE IF a.kind = "vi"  /\ b.kind = "vib" THEN si
      ELSE FALSE

\* == is "same precedence": version and pre-release equal, build metadata ignored.
Eq(a, b) ==
  IF Mutant = "legacy_eq_asymmetric" THEN OldEq(a, b)
  ELSE /\ a.ver = b.ver /\ PreRel(a) = PreRel(b)
       /\ (Mutant = "build_in_equality" => a.build = b.build)

Less(a, b) ==
  IF Mutant = "legacy_build_kinds_unordered"
     /\ (a.kind = "vb" \/ b.kind = "vb" \/ ((a.kind = "vib") # (b.kind = "vib")))
    THEN FALSE                                     \* pre-fix: unhandled pairs were FALSE
  ELSE IF Mutant = "legacy_prerelease_below_all" /\ PreRel(a) # <<>> /\ PreRel(b) = <<>>
    THEN TRUE                                      \* pre-fix: .vi < .v was always TRUE
  ELSE IF a.ver # b.ver THEN VLess(a.ver, b.ver)
  ELSE IF PreRel(a) = <<>> /\ PreRel(b) = <<>> THEN FALSE
  ELSE IF PreRel(b) = <<>> THEN Mutant # "prerelease_above_release"
  ELSE IF PreRel(a) = <<>> THEN Mutant = "prerelease_above_release"
  ELSE IdsLess(PreRel(a), PreRel(b))

\* semver.org precedence (build metadata ignored; no pre-release > pre-release)
RefLess(a, b) ==
  IF a.ver # b.ver THEN VLex(a.ver, b.ver)
  ELSE IF b.ids = <<>> THEN a.ids # <<>>
  ELSE IF a.ids = <<>> THEN FALSE
  ELSE RefIdsLess(a.ids, b.ids)

(* ---------------- text: description / init?(_:) ---------------- *)
DigitToks == {"0", "1", "01"}
DV(t) == IF t = "0" THEN 0 ELSE 1
Tok(n) == IF n = 0 THEN "0" ELSE "1"
IdValid == IF Mutant = "accept_leading_zero_id" THEN {"0", "1", "01", "alpha"}
           ELSE {"0", "1", "alpha"}                 \* "01" violates semver 9
BuildValid == {"0", "1", "01", "alpha", "b"}        \* build ids may have leading zeros
FAIL == [kind |-> "fail", ver |-> <<>>, ids |-> <<>>, build |-> <<>>]

PrintVer(x) == IF Mutant = "print_swaps_minor_patch"
                 THEN <<Tok(x[1]), ".", Tok(x[3]), ".", Tok(x[2])>>
                 ELSE <<Tok(x[1]), ".", Tok(x[2]), ".", Tok(x[3])>>
Print(a) ==
  PrintVer(a.ver) \o
  (IF a.kind = "v" THEN <<>>
   ELSE IF a.kind = "vi" THEN <<"-">> \o JoinDots(a.ids)
   ELSE IF a.kind = "vb" THEN <<"+">> \o JoinDots(a.build)
   ELSE <<"-">> \o JoinDots(a.ids) \o <<"+">> \o JoinDots(a.build))

ListOK(l, V) == l = <<>> \/ (Len(l) % 2 = 1 /\
                  \A k \in 1..Len(l) : IF k % 2 = 1 THEN l[k] \in V ELSE l[k] = ".")
Items(l) == [k \in 1..((Len(l) + 1) \div 2) |-> l[2 * k - 1]]
FirstPlus(r) == IF \E k \in 1..Len(r) : r[k] = "+"
                THEN CHOOSE k \in 1..Len(r) : r[k] = "+" /\ \A j \in 1..(k-1) : r[j] # "+"
                ELSE 0

\* Parsing.swift: OneOf { vib, vb, vi, v } and the parse must consume everything.
\* Parsing.swift: no leading zeros in major/minor/patch, and pre-release / build
\* lists need at least one item (Many(1...)).
CompOK(t) == t \in DigitToks /\ (t = "01" => Mutant = "legacy_leading_zero_component")
NonEmptyOK(l) == l # <<>> \/ Mutant = "legacy_empty_ids"
Parse(s) ==
  IF ~(Len(s) >= 5 /\ CompOK(s[1]) /\ s[2] = "." /\ CompOK(s[3])
       /\ s[4] = "." /\ CompOK(s[5])) THEN FAIL
  ELSE LET x == <<DV(s[1]), DV(s[3]), DV(s[5])>>
           r == SubSeq(s, 6, Len(s))
       IN IF r = <<>> THEN Mk("v", x, <<>>, <<>>)
          ELSE IF r[1] = "-" THEN
            LET body == Tail(r)
                p == FirstPlus(body)
            IN IF p = 0 THEN
                 (IF ListOK(body, IdValid) /\ NonEmptyOK(body)
                  THEN Mk("vi", x, Items(body), <<>>) ELSE FAIL)
               ELSE
                 LET il == SubSeq(body, 1, p - 1)
                     bl == SubSeq(body, p + 1, Len(body))
                 IN IF ListOK(il, IdValid) /\ ListOK(bl, BuildValid)
                       /\ NonEmptyOK(il) /\ NonEmptyOK(bl)
                    THEN Mk("vib", x, Items(il), Items(bl)) ELSE FAIL
          ELSE IF r[1] = "+" THEN
            LET bl == Tail(r)
            IN IF ListOK(bl, BuildValid) /\ NonEmptyOK(bl)
               THEN Mk("vb", x, <<>>, Items(bl)) ELSE FAIL
          ELSE FAIL

PVers      == {<<a, b, c>> : a, b, c \in 0..1}
\* values the parser can produce (non-empty lists); see README for hand-built .vi(ids: [])
PrintSems  == SemSet(PVers, NESeqs({"1", "alpha"}, 2), NESeqs({"b", "01"}, 2))
CandVers   == {<<a, ".", b, ".", c>> : a, b, c \in DigitToks}
IdLists    == Seqs({"1", "alpha", "01"}, 2)
BuildLists == Seqs({"b", "01"}, 2)
Suffixes ==
     {<<>>}
  \cup {<<"-">> \o JoinDots(i) : i \in IdLists}
  \cup {<<"+">> \o JoinDots(b) : b \in BuildLists}
  \cup {<<"-">> \o JoinDots(i) \o <<"+">> \o JoinDots(b) : i \in IdLists, b \in BuildLists}
Cands == {v \o sfx : v \in CandVers, sfx \in Suffixes}
Malformed == {
  <<"x">>, <<>>, <<"1", ".", "0">>, <<"1", "0", "0">>,
  <<"1", ".", "0", ".", "0", ".", "0">>, <<"1", ".", "0", ".">>,
  <<"x", ".", "0", ".", "0">>, <<"1", ".", "0", ".", "0", "x">>,
  <<"1", ".", "0", ".", "0", "-", "alpha", ".">>,
  <<"1", ".", "0", ".", "0", "-", "alpha", ".", ".", "1">>,
  <<"1", ".", "0", ".", "0", "+", "b", "+", "b">>,
  <<"1", ".", "0", ".", "0", "-", "alpha", "+", "b", "+", "b">>}

(* ================= invariants (all hold for the fixed code) ================= *)
TypeOK == u = 0 /\ OrdSems # {} /\ Cands # {}

\* --- components
IncNeverDecreases  == u = 0 => \A x \in Comps : Inc(x) >= x
IncSaturatesAtMax  == u = 0 => Inc(MaxC) = MaxC
DecSaturatesAtZero == u = 0 => Dec(0) = 0
IncIsSuccessor     == u = 0 => \A x \in Comps : x < MaxC => Inc(x) = x + 1 /\ Inc(x) > x
DecIsPredecessor   == u = 0 => \A x \in Comps : x > 0 => Dec(x) = x - 1 /\ Dec(x) < x
IncDecInverse      == u = 0 => \A x \in Comps : (x < MaxC => Dec(Inc(x)) = x) /\ (x > 0 => Inc(Dec(x)) = x)

\* --- Version.<
VersionIrreflexive == u = 0 => \A a \in AllVers : ~VLess(a, a)
VersionLessCoversLex == u = 0 => \A a, b \in AllVers : VLex(a, b) => VLess(a, b)
VersionLessSoundOnChains == u = 0 =>
  \A a, b \in AllVers : Comparable(a, b) => (VLess(a, b) <=> VLex(a, b))

\* --- identifiers
IdOrderMatchesSemver == u = 0 => \A i, j \in IdSet : IdLess(i, j) <=> RefIdLess(i, j)

\* --- Semantic ordering (sound fragments only)
StrictTotal(S) ==
  /\ \A a \in S : ~Less(a, a) /\ Eq(a, a)
  /\ \A a, b \in S : Less(a, b) => ~Less(b, a)
  /\ \A a, b \in S : Eq(a, b) <=> Eq(b, a)
  /\ \A a, b \in S : Less(a, b) \/ Less(b, a) \/ Eq(a, b)
  /\ \A a, b \in S : Eq(a, b) => ~Less(a, b)
  /\ \A a, b, c \in S : Less(a, b) /\ Less(b, c) => Less(a, c)
  /\ \A a, b, c \in S : Eq(a, b) /\ Eq(b, c) => Eq(a, c)
VOnlyIsStrictTotal  == u = 0 => StrictTotal(VOnly)
VIOnlyIsStrictTotal == u = 0 => StrictTotal(VIOnly)
VIOrderMatchesSemver == u = 0 =>
  \A a, b \in VOnly \cup VIOnly :
    (a.kind = b.kind \/ a.ver = b.ver) => (Less(a, b) <=> RefLess(a, b))
SameVersionPrereleaseBelowRelease == u = 0 =>
  \A a \in VIOnly : \A r \in VOnly : a.ver = r.ver =>
    (Less(a, r) /\ ~Less(r, a) /\ ~Eq(a, r) /\ ~Eq(r, a))
BuildMetadataIgnored == u = 0 =>
  \A a, b \in VIBOnly : (a.ver = b.ver /\ a.ids = b.ids) =>
    (Eq(a, b) /\ ~Less(a, b) /\ ~Less(b, a))
VIBOrdersLikeVI == u = 0 =>
  \A a, b \in VIBOnly :
    (Less(a, b) <=> Less(Strip(a), Strip(b))) /\ (Eq(a, b) <=> Eq(Strip(a), Strip(b)))
EqReflexiveAllKinds == u = 0 => \A a \in OrdSems : Eq(a, a)
EqSymmetricExceptVvb == u = 0 =>
  \A a, b \in OrdSems :
    ~({a.kind, b.kind} = {"v", "vb"} /\ a.kind # b.kind) => (Eq(a, b) => Eq(b, a))

\* --- text
ParsePrintRoundTrip == u = 0 => \A a \in PrintSems : Parse(Print(a)) = a
PrintParseOnCanonical == u = 0 =>
  \A s \in Cands :
    (s[1] # "01" /\ s[3] # "01" /\ s[5] # "01" /\ Parse(s) # FAIL) => Print(Parse(s)) = s
LeadingZeroIdRejected == u = 0 =>
  \A i \in IdLists : (\E k \in 1..Len(i) : i[k] = "01") =>
    \A v \in CandVers :
      /\ Parse(v \o <<"-">> \o JoinDots(i)) = FAIL
      /\ \A b \in BuildLists : Parse(v \o <<"-">> \o JoinDots(i) \o <<"+">> \o JoinDots(b)) = FAIL
MalformedRejected == u = 0 => \A m \in Malformed : Parse(m) = FAIL

(* ----- laws the pre-fix code violated (now in MajorMinorPatch.cfg) ----- *)
VersionLessAsymmetric == u = 0 => \A a, b \in AllVers : VLess(a, b) => ~VLess(b, a)
EqSymmetric == u = 0 => \A a, b \in OrdSems : Eq(a, b) => Eq(b, a)
PlainLessAsymmetric == u = 0 =>
  \A a, b \in VOnly \cup VIOnly : Less(a, b) => ~Less(b, a)
LessMatchesSemverAllKinds == u = 0 => \A a, b \in OrdSems : Less(a, b) <=> RefLess(a, b)
PrintParseLossless == u = 0 => \A s \in Cands : Parse(s) # FAIL => Print(Parse(s)) = s
ParseYieldsNonEmptyIds == u = 0 =>
  \A s \in Cands :
    (Parse(s) # FAIL /\ Parse(s).kind \in {"vi", "vib"}) => Parse(s).ids # <<>>
ParseYieldsNonEmptyBuild == u = 0 =>
  \A s \in Cands :
    (Parse(s) # FAIL /\ Parse(s).kind \in {"vb", "vib"}) => Parse(s).build # <<>>
LeadingZeroComponentRejected == u = 0 =>
  \A s \in Cands : (s[1] = "01" \/ s[3] = "01" \/ s[5] = "01") => Parse(s) = FAIL
VersionLessIsLex == u = 0 => \A a, b \in AllVers : VLess(a, b) <=> VLex(a, b)
\* precedence is a strict weak order over every case combination
AllKindsStrictWeakOrder == u = 0 => StrictTotal(OrdSems)
=============================================================================
