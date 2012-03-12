package Log::Stash::AMQP;
use Moose ();
use namespace::autoclean;

our $VERSION = "0.001";
$VERSION = eval $VERSION;

1;

=head1 NAME

Log::Stash::AMQP - input and output logstash messages via AMQP.

=head1 SYNOPSIS

    # Terminal 1:
    $ logstash --input STDIN --output AMQP --output_options '{"connect":"tcp://127.0.0.1:5558"}'
    {"data":{"some":"data"},"@metadata":"value"}

    # Terminal 2:
    $ logstash --output STDOUT --input AMQP --input_options '{"socket_bind":"tcp://*:5558"}'
    {"data":{"some":"data"},"@metadata":"value"}

=head1 DESCRIPTION

A L<AnyEvent::RabbitMQ> transport for L<Log::Stash>.

=head1 SEE ALSO

=over

=item L<Log::Stash::Output::AMQP>

=item L<Log::Stash::Input::AMQP>

=item L<Log::Stash>

=item L<AnyEvent::RabbitMQ>


=back

=head1 AUTHOR

Tomas (t0m) Doran <bobtfish@bobtfish.net>

=head1 COPYRIGHT

Copyright The above mentioned AUTHOR 2012.

=head1 LICENSE

GNU Affero General Public License, Version 3

If you feel this is too restrictive to be able to use this software,
please talk to us as we'd be willing to consider re-licensing under
less restrictive terms.

=cut

1;

