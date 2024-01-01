### P.4: Ideally, a program should be statically type safe[](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-philosophy#p4-ideally-a-program-should-be-statically-type-safe)

##### Reason

Ideally, a program would be completely statically (compile-time) type safe. Unfortunately, that is not possible. Problem areas:

-   unions
-   casts
-   array decay
-   range errors
-   narrowing conversions

##### Note

These areas are sources of serious problems (e.g., crashes and security violations). We try to provide alternative techniques.

##### Enforcement

We can ban, restrain, or detect the individual problem categories separately, as required and feasible for individual programs. Always suggest an alternative. For example:

-   unions – use `variant` (in C++17)
-   casts – minimize their use; templates can help
-   array decay – use `span` (from the GSL)
-   range errors – use `span`
-   narrowing conversions – minimize their use and use `narrow` or `narrow_cast` (from the GSL) where they are necessary

### P.5: Prefer compile-time checking to run-time checking[](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-philosophy#p5-prefer-compile-time-checking-to-run-time-checking)

##### Reason

Code clarity and performance. You don’t need to write error handlers for errors caught at compile time.

##### Example

```
// Int is an alias used for integers
int bits = 0;         // don't: avoidable code
for (Int i = 1; i; i <<= 1)
    ++bits;
if (bits < 32)
    cerr << "Int too small\n";
```

This example fails to achieve what it is trying to achieve (because overflow is undefined) and should be replaced with a simple `static_assert`:

```
// Int is an alias used for integers
static_assert(sizeof(Int) >= 4);    // do: compile-time check
```

Or better still just use the type system and replace `Int` with `int32_t`.

##### Example

```
void read(int* p, int n);   // read max n integers into *p

int a[100];
read(a, 1000);    // bad, off the end
```

better

```
void read(span<int> r); // read into the range of integers r

int a[100];
read(a);        // better: let the compiler figure out the number of elements
```

**Alternative formulation**: Don’t postpone to run time what can be done well at compile time.

##### Enforcement

-   Look for pointer arguments.
-   Look for run-time checks for range violations.


### P.7: Catch run-time errors early[](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-philosophy#p7-catch-run-time-errors-early)

##### Reason

Avoid “mysterious” crashes. Avoid errors leading to (possibly unrecognized) wrong results.

##### Example

```
void increment1(int* p, int n)    // bad: error-prone
{
    for (int i = 0; i < n; ++i) ++p[i];
}

void use1(int m)
{
    const int n = 10;
    int a[n] = {};
    // ...
    increment1(a, m);   // maybe typo, maybe m <= n is supposed
                        // but assume that m == 20
    // ...
}
```

Here we made a small error in `use1` that will lead to corrupted data or a crash. The (pointer, count)-style interface leaves `increment1()` with no realistic way of defending itself against out-of-range errors. If we could check subscripts for out of range access, then the error would not be discovered until `p[10]` was accessed. We could check earlier and improve the code:

```
void increment2(span<int> p)
{
    for (int& x : p) ++x;
}

void use2(int m)
{
    const int n = 10;
    int a[n] = {};
    // ...
    increment2({a, m});    // maybe typo, maybe m <= n is supposed
    // ...
}
```

Now, `m <= n` can be checked at the point of call (early) rather than later. If all we had was a typo so that we meant to use `n` as the bound, the code could be further simplified (eliminating the possibility of an error):

```
void use3(int m)
{
    const int n = 10;
    int a[n] = {};
    // ...
    increment2(a);   // the number of elements of a need not be repeated
    // ...
}
```

##### Example

Excess checking can be costly. There are cases where checking early is inefficient because you might never need the value, or might only need part of the value that is more easily checked than the whole. Similarly, don’t add validity checks that change the asymptotic behavior of your interface (e.g., don’t add a `O(n)` check to an interface with an average complexity of `O(1)`).

##### Enforcement

-   Look at pointers and arrays: Do range-checking early and not repeatedly
-   Look at conversions: Eliminate or mark narrowing conversions
-   Look for unchecked values coming from input
-   Look for structured data (objects of classes with invariants) being converted into strings


### P.8: Don’t leak any resources[](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-philosophy#p8-dont-leak-any-resources)

##### Reason

Even a slow growth in resources will, over time, exhaust the availability of those resources. This is particularly important for long-running programs, but is an essential piece of responsible programming behavior.

##### Example, bad

```
void f(char* name)
{
    FILE* input = fopen(name, "r");
    // ...
    if (something) return;   // bad: if something == true, a file handle is leaked
    // ...
    fclose(input);
}
```

Prefer [RAII](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#S-philosophy#Rr-raii):

```
void f(char* name)
{
    ifstream input {name};
    // ...
    if (something) return;   // OK: no leak
    // ...
}
```

