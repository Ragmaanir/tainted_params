= tainted_params

https://github.com/Ragmaanir/tainted_params

== DESCRIPTION:

Behaves like strong_parameters, with some minor differences.

== FEATURES:

- Validate required and optional parameters
- Validate their types
- Type coercions for parameters

== PROBLEMS/TODO:

- made some monkey patches to hash(slice, only, except, map_pairs) to not having to depend on active support gem
- custom HashWithIndifferentAccess

== SYNOPSIS:

  TaintedParams::ParamsValidatorBuilder.new do
    required :id, :Integer
    permitted :options, :Hash do
      permitted :name, :String
      permitted :active, :Boolean
    end
  end

== REQUIREMENTS:

* Ruby >= 2

== INSTALL:

* FIX

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== INTERNALS

The ParamsValidatorBuilder constructs a ParamsValidator out of ParamConstraints. The ParamsValidator contains the validation logic to split a params-hash into valid, invalid, missing and unpermitted parts.

== LICENSE:

(The MIT License)

Copyright (c) 2015 Ragmaanir

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
