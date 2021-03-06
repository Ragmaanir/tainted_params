# tainted_params

https://github.com/Ragmaanir/tainted_params

## Description

Behaves like strong_parameters, with some minor differences.

## Features

- Validate required and optional parameters
- Validate their types
- Type coercions for parameters

## Problems/Todo

- get rid of activesupport dependency

## Synopsis

    builder = TaintedParams::ParamsValidatorBuilder.new do
      required :id, :Integer
      optional :options, :Hash do
        optional :name, :String
        optional :active, :Boolean
      end
    end

    validator = builder.result

    result = validator.validate(options: { name: 'bob', active: 1, admin: true })

    # These evaluate to true:
    result.valid        == { options: { name: 'bob' } }
    result.invalid      == { options: { active: 1 } }
    result.unpermitted  == { options: { admin: true } }
    result.missing      == { id: nil }

## Requirements

* Ruby >= 2
* activesupport

## Install

* gem install tainted_params

## Developers

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

## Internals

The ParamsValidatorBuilder constructs a ParamsValidator out of ParamConstraints. The ParamsValidator contains the validation logic to split a params-hash into valid, invalid, missing and unpermitted parts.

## License

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
