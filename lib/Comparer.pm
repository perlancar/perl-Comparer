## no critic: TestingAndDebugging::RequireUseStrict
package Comparer;

# AUTHORITY
# DATE
# DIST
# VERSION

1;
# ABSTRACT: Reusable comparer subroutines

=head1 SPECIFICATION VERSION

0.1


=head1 SYNOPSIS

Basic:

 use Comparer::naturally;
 my $cmp = Comparer::naturally::gen_comparer;

 my @sorted = sort { $cmp->($a,$b) } ('track1.mp3', 'track10.mp3', 'track2.mp3', 'track1b.mp3', 'track1a.mp3');
 # => ('track1.mp3', 'track1a.mp3', 'track1b.mp3', 'track2.mp3', 'track10.mp3')

Specifying arguments:

 use Comparer::naturally;
 my $cmp = Comparer::naturally::gen_comparer(reverse => 1);
 my @sorted = sort { $cmp->($a,$b) } ...;

Specifying comparer on the command-line (for other CLI's):

 % customsort -c naturally ...
 % customsort -c naturally=reverse,1 ...


=head1 DESCRIPTION

B<EXPERIMENTAL. SPEC MIGHT STILL CHANGE.>

=head1 Glossary

A B<comparer> is a subroutine that accepts two items to be compare and return a
value of either -1/0/1. So in other words, just like Perl's C<cmp> or C<< <=>
>>.

A B<comparer module> is a module under the C<Comparer::*> namespace that you can
use to generate a comparer.

=head2 Writing a Comparer module

 package Comparer::naturally;

 # required. must return a hash (DefHash)
 sub meta {
     return +{
         v => 1,
         args => {
             reverse => {
                 schema => 'bool*', # Sah schema
             },
         },
     };
 }

 sub gen_comparer {
     my %args = @_;
     ...
 }

 1;

=head2 Namespace organization


=head1 SEE ALSO

Base specifications: L<DefHash>, L<Sah>.

Related: L<Sorter>

Previous incarnation: L<Sort::Sub>. C<Sorter> and C<Comparer> are meant to
eventually supersede Sort::Sub. The main improvement upon Sort::Sub is the split
into three kinds of subroutines: 1) a sorter (a subroutine that accepts a list
of items to sort), where C<Sorter::*> modules are meant to generate; 2) a
keymaker (a subroutine that converts an item to a string/numeric key suitable
for simple comparison using C<eq> or C<==> during sorting); you can use
C<Data::Sah::Value::perl::KeyMaker> namespace for this; and 3) comparer (a
subroutine that compares two items that can be used in C<sort()>), where
C<Comparer::*> modules are meant to generate. Perl's C<sort()> allows us to
specify a comparer, but oftentimes it's more efficient to sort by key using a
keymaker, and sometimes due to preprocessing and/or postprocessing it's more
suitable to use the more generic C<sorter> interface.
