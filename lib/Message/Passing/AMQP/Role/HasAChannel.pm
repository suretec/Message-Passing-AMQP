package Message::Passing::AMQP::Role::HasAChannel;
use Moose::Role;
use Scalar::Util qw/ weaken /;
use AnyEvent;
use AnyEvent::RabbitMQ;
use namespace::autoclean;

has hostname => (
    is => 'ro',
    isa => 'Str',
    default => 'localhost',
);

has port => (
    is => 'ro',
    isa => 'Int',
    default => 5672,
);

has [qw/ username password /] => (
    is => 'ro',
    isa => 'Str',
    default => 'guest',
);

has vhost => (
    is => 'ro',
    isa => 'Str',
    default => '/',
);

has timeout => (
    is => 'ro',
    isa => 'Int',
    default => 10,
);

has _connecting_timer => (
    is => 'ro',
    clearer => '_clear_connecting_timer',
    predicate => '_am_connecting',
    reader => '_start_connecting',
    lazy => 1,
    default => sub {
        my $self = shift;
        weaken $self;
        AnyEvent->timer(after => $self->timeout, cb => sub {
            $self->_clear_connection;
            $self->_clear_connecting_timer;
            my $idle; $idle = AnyEvent->idle(cb => sub {
                $self->_connection;
                undef $idle;
            });
        });
    },
);

has _channel => (
    is => 'ro',
    writer => '_set_channel',
    clearer => '_clear_channel',
);

sub connected {
    my $self = shift;
    weaken($self);
    $self->_connection->open_channel(
        on_success => sub {
            my $channel = shift;
            $self->_set_channel($channel);
        },
        on_failure => sub {
            $self->_clear_channel;
        },
        on_close => sub {
            $self->_clear_channel;
        },
    );
}
sub disconnected {}

has _connection_verbose => (
    is => 'ro',
    isa => 'Bool',
    default => 0,
);

has _connection => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        weaken($self);
        $self->_start_connecting;
        AnyEvent::RabbitMQ->new(
            verbose => $self->_connection_verbose,
        )->load_xml_spec()->connect(
            host       => $self->hostname,
            port       => $self->port,
            user       => $self->username,
            pass       => $self->password,
            vhost      => $self->vhost,
            timeout    => $self->timeout,
            on_success => sub {
                $self->connected();
                $self->_clear_connecting_timer;
            },
            on_failure => sub {
                $self->disconnected();
                $self->_clear_connection;
            },
            on_close => sub {
                $self->disconnected();
                $self->_clear_connection;
            },
        );
    },
    clearer => '_clear_connection',
);

1;

=head1 NAME

Message::Passing::AMQP::HasAChannel - Role for instances which have an AMQP channel.

=head1 ATTRIBUTES

=head1 METHODS

=head2 connected

Called when the channel has connected

=head2 disconnected

Called when the channel disconnects.

=head1 AUTHOR, COPYRIGHT AND LICENSE

See L<Message::Passing::AMQP>.

=cut

