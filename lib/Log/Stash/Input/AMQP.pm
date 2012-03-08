package Log::Stash::Input::AMQP;
use Moose;
use AnyEvent;
use namespace::autoclean;

with qw/
    Log::Stash::AMQP::Role::HasAChannel
    Log::Stash::Role::Input
/;


1;

=head1 NAME

Log::Stash::Input::AMQP - input logstash messages from ZeroMQ.

=head1 DESCRIPTION

=head1 SEE ALSO

=over

=item L<Log::Stash::AMQP>

=item L<Log::Stash::Output::AMQP>

=item L<Log::Stash>

=item L<AMQP>

=item L<http://www.zeromq.org/>

=back

=head1 SPONSORSHIP

This module exists due to the wonderful people at Suretec Systems Ltd.
<http://www.suretecsystems.com/> who sponsored it's development for its
VoIP division called SureVoIP <http://www.surevoip.co.uk/> for use with
the SureVoIP API - 
<http://www.surevoip.co.uk/support/wiki/api_documentation>

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Log::Stash>.

=cut

