use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/Message/Passing/AMQP.pm';

license 'AGPL_3';

requires 'Moose';
requires 'namespace::autoclean';
requires 'AnyEvent';
requires 'AnyEvent::RabbitMQ' => '1.05';
requires 'JSON';
requires 'JSON::XS';
requires 'Try::Tiny';
requires 'Task::Weaken';
requires 'Message::Passing' => '0.001';

test_requires 'Test::More' => '0.88';

author_requires 'Test::Pod' => '1.14';
author_requires 'Test::NoTabs';
author_requires 'Test::Pod::Coverage' => '1.04';
author_requires 'Pod::Coverage' => '0.19';
author_requires 'Pod::Coverage::TrustPod';
author_requires 'Test::Spelling';

author_tests 't/author';

if ($Module::Install::AUTHOR) {
    system("pod2text lib/Message/Passing/AMQP.pm > README")
        and die $!;
}

WriteAll;

