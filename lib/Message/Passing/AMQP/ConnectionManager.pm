package Message::Passing::AMQP::ConnectionManager;
use Moose;
use Scalar::Util qw/ weaken /;
use AnyEvent;
use AnyEvent::RabbitMQ;
use Carp qw/ croak /;
use namespace::autoclean;

with qw/
    Message::Passing::Role::ConnectionManager
    Message::Passing::Role::HasHostnameAndPort
/;

sub _default_port { 5672 }

has [qw/ username password /] => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has vhost => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has timeout => (
    is => 'ro',
    isa => 'Int',
    default => sub { 30 },
);

has verbose => (
    is => 'ro',
    isa => 'Bool',
    default => sub { 0 },
);

my $has_loaded;
sub _build_connection {
    my $self = shift;
    weaken($self);
    my $client = AnyEvent::RabbitMQ->new(
        verbose => $self->verbose,
    );
    $client->load_xml_spec unless $has_loaded++;
    $client->connect(
        host       => $self->hostname,
        port       => $self->port,
        user       => $self->username,
        pass       => $self->password,
        vhost      => $self->vhost,
        timeout    => $self->timeout,
        on_success => sub {
            $self->_set_connected(1);
        },
        on_failure => sub {
            my ($error) = @_;
            warn("CONNECT ERROR $error");
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
1;

