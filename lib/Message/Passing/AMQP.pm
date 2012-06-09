package Message::Passing::AMQP;
use Moose ();
use namespace::autoclean;

our $VERSION = "0.001";
$VERSION = eval $VERSION;

1;

=head1 NAME

Message::Passing::AMQP - input and output message-pass messages via AMQP.

=head1 SYNOPSIS

    # Terminal 1:
    $ message-pass --input STDIN --output AMQP --output_options '{"exchange_name":"test"}'
    {"data":{"some":"data"},"@metadata":"value"}

    # Terminal 2:
    $ message-pass --output STDOUT --input AMQP --input_options '{"queue_name":"test","exchange_name":"test"}'
    {"data":{"some":"data"},"@metadata":"value"}

=head1 DESCRIPTION

An AMQP adaptor for L<Message::Passing> for speaking to AMQP servers, for example L<RabbitMQ|http://www.rabbitmq.com/> or QPID.

=head1 PROTOCOL VERSION

This adaptor uses the 0.8 version of the AMQP protocol, as currently shipped with L<AnyEvent::RabbitMQ>.

=head1 SEE ALSO

=over

=item L<Message::Passing::Output::AMQP>

=item L<Message::Passing::Input::AMQP>

=item L<Message::Passing>

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

