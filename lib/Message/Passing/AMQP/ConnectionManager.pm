package Message::Passing::AMQP::ConnectionManager;
use Moose;
use Scalar::Util qw/ weaken /;
use AnyEvent;
use AnyEvent::RabbitMQ;
use Carp qw/ croak /;
use Try::Tiny qw/ try /;
use namespace::autoclean;

with 'Message::Passing::Role::ConnectionManager';

has hostname => (
    is => 'ro',
    isa => 'Str',
    default => 'localhost',
);

has port => (
    is => 'ro',
    isa => 'Int',
    default => 6163,
);

has [qw/ username password /] => (
    is => 'ro',
    isa => 'Str',
    default => 'guest',
);

has vhost => (
    is => 'ro',
    isa => 'Str',
    default => sub { '/' },
);

has timeout => (
    is => 'ro',
    isa => 'Int',
    default => sub { 30 },
);

has verbose => (
    is => 'ro',
    isa => 'Bool',
    default => sub { 1 },
);

my $client ||=  AnyEvent::RabbitMQ->new(
    verbose => 1,
)->load_xml_spec;
sub _build_connection {
    my $self = shift;
    weaken($self);
    $client->connect(
        host       => $self->hostname,
        port       => $self->port,
        user       => $self->username,
        pass       => $self->password,
        vhost      => $self->vhost,
        timeout    => $self->timeout,
        on_success => sub {
            warn "CONNECTED";
            $self->_set_connected(1);
        },
        on_failure => sub {
            warn("CONNECT ERROR");
            $self->_set_connected(0);
        },
        on_close => sub {
            warn("CLOSED");
            $self->_set_connected(0);
        },
    );
    return $client;
}

__PACKAGE__->meta->make_immutable;

