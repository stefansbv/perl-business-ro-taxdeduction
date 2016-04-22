Business-RO-TaxDeduction
========================
Ștefan Suciu
2016-04-21

Version: 0.003

A Romanian salary tax deduction calculator.

This version is up to date vith the current regulations (OMFP 52/2016).

The previous versions used OMFP 1016/2005.

This is an alternative to the database driven implementation for
calculation the tax deductions.  It may be suitable for small programs
or even for oneliners line this:

```
$ perl -MBusiness::RO::TaxDeduction -E'$td=Business::RO::TaxDeduction->new(vbl=>1400);say $td->tax_deduction'
300
```

It's a little too long but it works ;)
