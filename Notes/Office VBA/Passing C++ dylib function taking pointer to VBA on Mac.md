Here is an answer (designed thank to [this](https://support.microsoft.com/en-us/kb/205277)) in the case of arrays : to pass an array (of double) from c++ to excel-2011's (mac) VBA, the c++ function should have in its signature a `double *` representing the pointer to the first coefficient of the array, an `int` (or a `long` or etc) reprensenting the size of the array. For instance, a function taking an array and multiplying all its coefficients by a parameter value would be coded like this : the c++ code is :

```c
extern "C"
{
      void multarray(double * array, int size, double coeff)
      {
            for (int i = 0 ; i < size ; ++i)
            {
                  array[i]*=coeff;
            }
      }
}
```

compiled with :

```bash
g++ -m32 -Wall -g -c ./tmp4.cpp
g++ -m32 -dynamiclib ./tmp4.o -o ./tmp4.dylib
```

Now the VBA should reference the dylib as follows :
```vb
Declare Sub multarray Lib "/Users/XXXXXX/Documents/GITHUBRepos/DYLIBS/MyFirstDylib/tmp4.dylib" (ByRef firstcoeff As Double, ByVal size As Long, ByVal coeff As Double)
```

The first parameter of `multarray` represent the first coefficient of the array, _and must be passed by reference_. Here is an exemple of utilisation :

```vb
Public Sub DoIt()
    Dim multarraofdoubles(3) As Double
    multarraofdoubles(0) = -1.3
    multarraofdoubles(1) = 4.6
    multarraofdoubles(2) = -0.67
    multarraofdoubles(3) = 3.13
    Dim coeff As Double
    coeff = 2#
    Call multarray(multarraofdoubles(0), 4, coeff)
End Sub
```

