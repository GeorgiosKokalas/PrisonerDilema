/* MyMEXFunction
 * c = MyMEXFunction(a,b);
 * Adds offset argument a to each element of double array b and
 * returns the modified array c.
*/

#include "mex.hpp"
#include "matrix.h"
#include "mexAdapter.hpp"
#include <Windows.h>
#include <Xinput.h>
#include <iostream>

using namespace matlab::data;
using matlab::mex::ArgumentList;

class MexFunction : public matlab::mex::Function {
public:
    void operator()(ArgumentList outputs, ArgumentList inputs) {
        ArrayFactory factory;
        TypedArray<double> a = std::move(inputs[0]);
        a[0] = a[0]+1;
        mx
        outputs[0] = a;
    }

};