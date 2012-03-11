package Log::Stash::AMQP::Role::BindsQueues;
use Moose::Role;
use Data::Dumper;
use namespace::autoclean;

with 'Log::Stash::AMQP::Role::HasChannel';

method bind_queue ($queue_name, $exchange_name, $routing_key) {
    my $bind_frame = $self->_channel->bind_queue(
       queue => $queue_name,
       exchange => $exchange_name,
       routing_key => $routing_key,
    );
    die "Bad bind to queue $queue_name " . Dumper($bind_frame)
            unless blessed $bind_frame->method_frame
                and $bind_frame->method_frame->isa('Net::AMQP::Protocol::Queue::BindOk');
    return 1;
}

1;
